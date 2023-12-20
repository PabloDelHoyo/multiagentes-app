FROM tiangolo/uvicorn-gunicorn:python3.10-slim

RUN pip install --no-cache-dir --upgrade cryptography

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY ./app /app
