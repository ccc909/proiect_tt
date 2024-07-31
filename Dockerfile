# Use the latest python image
FROM python:latest

# Install Node Exporter
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz && \
    tar -xzf node_exporter-1.5.0.linux-amd64.tar.gz && \
    mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/ && \
    rm -rf node_exporter-1.5.0.linux-amd64*

# Set PYTHONUNBUFFERED environment variable
ENV PYTHONUNBUFFERED=1

# Copy your application code
COPY ./src /app
WORKDIR /app

# Start your application, sleep for 3 seconds, then start node exporter
CMD ["sh", "-c", "python main.py & sleep 3 && node_exporter"]
