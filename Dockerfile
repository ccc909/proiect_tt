FROM python:latest

ENV PROMETHEUS_VERSION=2.46.0
ENV NODE_EXPORTER_VERSION=1.6.0

# Install dependencies and Prometheus
RUN apt-get update && apt-get install -y wget tar && \
    wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
    tar xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/ && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/ && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/consoles /etc/prometheus/ && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/console_libraries /etc/prometheus/ && \
    rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz prometheus-${PROMETHEUS_VERSION}.linux-amd64

# Install Node Exporter
RUN wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz && \
    tar xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz && \
    mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/ && \
    rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64

# Create Prometheus configuration file
RUN mkdir -p /etc/prometheus && \
    echo "global:\n  scrape_interval: 15s\n\nscrape_configs:\n  - job_name: 'prometheus'\n    static_configs:\n      - targets: ['localhost:9090']\n  - job_name: 'node'\n    static_configs:\n      - targets: ['localhost:9100']" > /etc/prometheus/prometheus.yml

EXPOSE 9090 9100

COPY ./src /app
WORKDIR /app

CMD ["sh", "-c", "exec prometheus --config.file=/etc/prometheus/prometheus.yml & exec node_exporter & exec python main.py"]
