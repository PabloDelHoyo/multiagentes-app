from __future__ import annotations

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import models


class QueryBuilder:

    def __init__(self, search_filter: models.SearchFilter, schema: str, table_name: str):
        # NOTE: schema and table_name must have been properly sanatized
        self.search_filter = search_filter

        self._count = -1
        self._buff = f"SELECT * FROM {schema}.{table_name} WHERE "

    def build(self):
        if self._count == -1:
            self._buff += self._build_where_clause(self.search_filter)

        return self._buff

    def params(self) -> dict[str, models.FilterValue]:
        return {str(i): value for i, value in enumerate(self.search_filter.all_values())}

    def _build_where_clause(self, search_filter: models.SearchFilter):
        where_clause = []
        for comparison in search_filter.filters:
            if isinstance(comparison, models.Filter):
                where_clause.append(self._build_comparison(comparison))
            else:
                where_clause.append(
                    f"({self._build_where_clause(comparison)})")

        if search_filter.operation != models.BoolOp.NOT:
            return f" {search_filter.operation} ".join(where_clause)

        joined_clause = " AND ".join(where_clause)
        return f"NOT ({joined_clause})"

    def _build_comparison(self, comparison: models.Filter):
        self._count += 1
        return f"`{comparison.column}`{comparison.comparison_op.value}:{self._count}"
