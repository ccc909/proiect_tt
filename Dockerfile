FROM python:latest

RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz && \
    tar -xzf node_exporter-1.5.0.linux-amd64.tar.gz && \
    mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/ && \
    rm -rf node_exporter-1.5.0.linux-amd64*

ENV PYTHONUNBUFFERED=1

COPY ./src /app
WORKDIR /app

CMD ["sh", "-c", "python main.py & sleep 3 && node_exporter"]
