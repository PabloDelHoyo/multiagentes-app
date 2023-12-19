import os
import sqlalchemy as sa

_DB_PASSWORD_FILE = os.getenv("DB_PASSWORD_FILE")
with open(_DB_PASSWORD_FILE) as f:
    password = f.read().strip()

_DB_USER_FILE = os.getenv("DB_USER_FILE")
if _DB_USER_FILE:
    with open(_DB_USER_FILE) as f:
        username = f.read().strip()
else:
    username = "root"


_DB_URL = sa.URL.create(
    "mysql+pymysql",
    username=username,
    password=password,
    host=os.getenv("DB_HOST", "mineriadb"),
    port=3306,
)

# https://stackoverflow.com/questions/55617520/unable-to-make-tls-tcp-connection-to-remote-mysql-server-with-pymysql-other-too
_engine = sa.create_engine(_DB_URL, connect_args={
    "ssl": {"fake_tls_flag": True}
})


def get_connection():
    with _engine.connect() as conn:
        yield conn


def does_table_exist(conn: sa.Connection, schema: str, table: str):
    table_exists = conn.execute(sa.text(
        """SELECT table_name
        FROM information_schema.TABLES
        WHERE table_schema=:schema AND table_name=:table_name"""
    ), dict(
        schema=schema,
        table_name=table
    )).first() is not None

    return table_exists
