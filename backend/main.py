from __future__ import annotations

from typing import Annotated
from enum import Enum
import os

import sqlalchemy as sa
from pydantic import BaseModel, Field
import pandas as pd

from fastapi import FastAPI, Depends, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(root_path=os.getenv("ROOT_PATH", ""))
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

DB_PASSWORD_FILE = os.getenv("DB_PASSWORD_FILE")
with open(DB_PASSWORD_FILE) as f:
    password = f.read().strip()

DB_USER_FILE = os.getenv("DB_USER_FILE")
if DB_USER_FILE:
    with open(DB_USER_FILE) as f:
        username = f.read().strip()
else:
    username = "root" 


DB_URL = sa.URL.create(
    "mysql+pymysql",
    username=username,
    password=password,
    host=os.getenv("DB_HOST", "mineriadb"),
    port=3306,
)

# https://stackoverflow.com/questions/55617520/unable-to-make-tls-tcp-connection-to-remote-mysql-server-with-pymysql-other-too
engine = sa.create_engine(DB_URL, connect_args={
	"ssl": {"fake_tls_flag": True}
})


class DBSchema(str, Enum):
    RAW = "raw"
    SILVER = "silver"
    GOLD = "gold"


class DBSchemaInfo(BaseModel):
    name: str
    columns: list[str]
    records_count: int

class ComparisonOp(str, Enum):
    EQ = "="
    GE = ">="
    LE = "<="
    LT = "<"
    GT = ">"

class BoolOp(str, Enum):
    AND = "AND"
    OR = "OR"
    NOT = "NOT"

class Car(BaseModel):
    brand: str
    model: str

class RecommendatorParams(BaseModel):
    max_price: float
    min_num_seats: float
    autonomy: float
    autonomy_margin: float=150

FilterValue = str | float | int

class Filter(BaseModel):
    column: str
    comparison_op: ComparisonOp
    value: FilterValue


class SearchFilter(BaseModel):
    operation: BoolOp
    filters: Annotated[list[Filter | SearchFilter], Field(min_length=1)]

    def all_column_names(self) -> set[str]:
        columns = set()
        for filter in self.filters:
            if isinstance(filter, SearchFilter):
                columns |= filter.all_column_names()
            else:
                columns.add(filter.column)
        return columns
    
    def all_values(self) -> list[FilterValue]:
        values = []

        for filter in self.filters:
            if isinstance(filter, SearchFilter):
                values += filter.all_values()
            else:
                values.append(filter.value)

        return values

class QueryBuilder:

    def __init__(self, search_filter: SearchFilter, schema: str, table_name: str):
        # NOTE: schema and table_name must have been properly sanatized
        self.search_filter = search_filter

        self._count = -1
        self._buff = f"SELECT * FROM {schema}.{table_name} WHERE "
    
    def build(self):
        if self._count == -1:
            self._buff += self._build_where_clause(self.search_filter)

        return self._buff
    
    def params(self) -> dict[str, FilterValue]:
        return {str(i): value for i, value in enumerate(self.search_filter.all_values())}
        
    def _build_where_clause(self, search_filter: SearchFilter):
        where_clause = []
        for comparison in search_filter.filters:
            if isinstance(comparison, Filter):
                where_clause.append(self._build_comparison(comparison))
            else:
                where_clause.append(f"({self._build_where_clause(comparison)})")
        
        if search_filter.operation != BoolOp.NOT:
            return f" {search_filter.operation} ".join(where_clause)
        
        joined_clause = " AND ".join(where_clause)
        return f"NOT ({joined_clause})"

    def _build_comparison(self, comparison: Filter):
        self._count += 1
        return f"`{comparison.column}`{comparison.comparison_op.value}:{self._count}"


def get_db_connection():
    with engine.connect() as conn:
        yield conn


@app.get("/{db_schema}", response_model=list[DBSchemaInfo])
def get_schema(db_schema: DBSchema, conn: Annotated[sa.Connection, Depends(get_db_connection)]):
    column_results = conn.execute(sa.text(
        """SELECT table_name AS name, column_name AS column_name
        FROM information_schema.COLUMNS 
        WHERE table_schema=:schema"""),
        dict(
            schema=db_schema,
        )
    )

    record_count_results = conn.execute(sa.text(
        """SELECT table_name AS name, table_rows AS records_count
        FROM information_schema.TABLES
        WHERE table_schema=:schema"""
    ), dict(
        schema=db_schema
    ))

    table_to_count = dict(list(record_count_results))

    data = {}
    for row in column_results:
        if row.name not in data:
            data[row.name] = []
        data[row.name].append(row.column_name)

    return [{"name": name, "columns": columns, "records_count": table_to_count[name]}
            for name, columns in data.items()
    ]

@app.get("/{db_schema}/{table_name}")
def get_table(
    db_schema: DBSchema,
    table_name: str,
    conn: Annotated[sa.Connection, Depends(get_db_connection)],
    offset: Annotated[int, Query(ge=0)]=0,
    size: Annotated[int, Query(ge=0)]=10
):
    table_exists = conn.execute(sa.text(
        """SELECT table_name
        FROM information_schema.TABLES
        WHERE table_schema=:schema AND table_name=:table_name"""
    ), dict(
        schema=db_schema,
        table_name=table_name
    )).first() is not None
    
    if not table_exists:
        raise HTTPException(
            status_code=404, detail=f"The table '{table_name}' could not be found in '{db_schema}'"
        )
    
    # This query is safe against SQL injection attacks because we previously check if db_schame.table_name
    # exists
    results = conn.execute(sa.text(
        f"SELECT * FROM {db_schema}.{table_name} LIMIT :size OFFSET :offset"
    ), dict(
        size=size,
        offset=offset
    ))

    return list(results.mappings())

# TODO: document params
@app.post("/{db_schema}/{table_name}/search")
def submit_search(
    db_schema: DBSchema,
    table_name: str,
    search_filter: SearchFilter | list[SearchFilter | Filter],
    conn: Annotated[sa.Connection, Depends(get_db_connection)],
    offset: Annotated[int, Query(ge=0)]=0,
    size: Annotated[int, Query(ge=0)]=10
):
    # TODO: this should be a dependency
    table_exists = conn.execute(sa.text(
        """SELECT table_name
        FROM information_schema.TABLES
        WHERE table_schema=:schema AND table_name=:table_name"""
    ), dict(
        schema=db_schema,
        table_name=table_name
    )).first() is not None
    
    if not table_exists:
        raise HTTPException(
            status_code=404, detail=f"The table '{table_name}' could not be found in '{db_schema}'"
        )

    if isinstance(search_filter, list):
        search_filter = SearchFilter(operation=BoolOp.AND, filters=search_filter)
    
    column_names = search_filter.all_column_names()
    where_clause = " OR ".join([f"column_name=:{i}" for i in range(len(column_names))])
    params = {str(i) : column_name for i, column_name in enumerate(column_names)}

    check_query = conn.execute(sa.text(
        f"""SELECT column_name AS column_name
        FROM information_schema.COLUMNS
        WHERE table_schema=:schema AND table_name=:table_name AND ({where_clause})"""
    ), dict(
        schema=db_schema,
        table_name=table_name,
        **params)
    )

    if check_query.rowcount != len(column_names):
        result = {column_name for column_name, in check_query}
        raise HTTPException(status_code=404, detail={
            "msg": "Some columns do not exist",
            "columns": list(column_names - result)
        })
    
    builder = QueryBuilder(search_filter, db_schema, table_name)
    query = builder.build()

    result = conn.execute(
        sa.text(query + " LIMIT :limit OFFSET :offset"), 
        dict(offset=offset, limit=size, **builder.params())
    )

    return list(result.mappings())

@app.post("/recommend", response_model=list[Car])
def recommend(
    params: RecommendatorParams,
    conn: Annotated[sa.Connection, Depends(get_db_connection)]
):
    df = pd.read_sql_table("recomendador", conn, schema="gold")

    df = df[df['Seats'] >= params.min_num_seats]
    df = df[df['PriceEuro'] <= params.max_price]
    df = df[(df['Range_Km'] >= (params.autonomy-params.autonomy_margin)) & 
            (df['Range_Km'] <= (params.autonomy+params.autonomy_margin))]
    
    return df[["Brand", "Model"]].rename(columns=str.lower).to_dict("records")