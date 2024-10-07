#!/bin/bash

# Update package list
sudo apt update

# Install required packages
sudo apt install -y wget tar

# Create directories for Prometheus and Node Exporter
sudo mkdir -p /etc/prometheus
sudo mkdir -p /etc/node_exporter

# Download and extract Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v3.0.0-beta.0/prometheus-3.0.0-beta.0.linux-amd64.tar.gz
tar -xvzf prometheus-3.0.0-beta.0.linux-amd64.tar.gz
sudo mv prometheus-3.0.0-beta.0.linux-amd64/* /etc/prometheus/

# Create Prometheus systemd service file
cat <<EOL | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/etc/prometheus/prometheus --config.file=/etc/prometheus/prometheus.yml
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Create Prometheus configuration file
cat <<EOL | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: node
    static_configs:
      - targets: ['localhost:9100']
EOL

# Download and extract Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
tar -xvzf node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv node_exporter-1.8.2.linux-amd64/* /etc/node_exporter/

# Create Node Exporter systemd service file
cat <<EOL | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/etc/node_exporter/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd to recognize new services
sudo systemctl daemon-reload

# Enable and start Prometheus and Node Exporter services
sudo systemctl enable prometheus.service
sudo systemctl start prometheus.service

sudo systemctl enable node_exporter.service
sudo systemctl start node_exporter.service

# Check the status of both services
sudo systemctl status prometheus.service
sudo systemctl status node_exporter.service

echo "Prometheus and Node Exporter installation completed."
