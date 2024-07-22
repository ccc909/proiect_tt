FROM python:latest

COPY ./src /app
WORKDIR /app

ENTRYPOINT ["python", "main.py"]