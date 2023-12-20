from __future__ import annotations

from typing import Annotated

from enum import Enum
from pydantic import BaseModel, Field


class DBSchema(str, Enum):
    RAW = "raw"
    SILVER = "silver"
    GOLD = "gold"


class DBSchemaInfo(BaseModel):
    name: str
    columns: list[str]
    records_count: int


class ComparisonOp(str, Enum):
    NE = "!="
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
    autonomy_margin: float = 150


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
