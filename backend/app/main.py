from __future__ import annotations

from typing import Annotated
import os

import sqlalchemy as sa
import pandas as pd

from fastapi import FastAPI, Depends, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware

import models
import db
from query_builder import QueryBuilder

app = FastAPI(root_path=os.getenv("ROOT_PATH", ""))
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


def check_table_exists(conn: sa.Connection, schema: str, table: str):
    if not db.does_table_exist(conn, schema, table):
        raise HTTPException(
            status_code=404, detail=f"The table '{table}' could not be found in '{schema}'"
        )


@app.get("/{db_schema}", response_model=list[models.DBSchemaInfo])
def get_schema(db_schema: models.DBSchema, conn: Annotated[sa.Connection, Depends(db.get_connection)]):
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
    db_schema: models.DBSchema,
    table_name: str,
    conn: Annotated[sa.Connection, Depends(db.get_connection)],
    offset: Annotated[int, Query(ge=0)] = 0,
    size: Annotated[int, Query(ge=0)] = 10
):
    # TODO: there has to be a way to make this a FastAPI dependency
    check_table_exists(conn, db_schema, table_name)

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
    db_schema: models.DBSchema,
    table_name: str,
    search_filter: models.SearchFilter | list[models.SearchFilter | models.Filter],
    conn: Annotated[sa.Connection, Depends(db.get_connection)],
    offset: Annotated[int, Query(ge=0)] = 0,
    size: Annotated[int, Query(ge=0)] = 10
):
    # TODO: there has to be a way to make this a FastAPI dependency
    check_table_exists(conn, db_schema, table_name)

    if isinstance(search_filter, list):
        search_filter = models.SearchFilter(
            operation=models.BoolOp.AND, filters=search_filter)

    column_names = search_filter.all_column_names()
    where_clause = " OR ".join(
        [f"column_name=:{i}" for i in range(len(column_names))])
    params = {str(i): column_name for i,
              column_name in enumerate(column_names)}

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


@app.post("/recommend", response_model=list[models.Car])
def recommend(
    params: models.RecommendatorParams,
    conn: Annotated[sa.Connection, Depends(db.get_connection)]
):
    df = pd.read_sql_table("recomendador", conn, schema="gold")

    df = df[df['Seats'] >= params.min_num_seats]
    df = df[df['PriceEuro'] <= params.max_price]
    df = df[(df['Range_Km'] >= (params.autonomy-params.autonomy_margin)) &
            (df['Range_Km'] <= (params.autonomy+params.autonomy_margin))]

    return df[["Brand", "Model"]].rename(columns=str.lower).to_dict("records")
