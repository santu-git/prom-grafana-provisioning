#!/bin/bash
# All command will be run as root

echo "[TASK 1] Installing and Configuring Promethus Server"
echo "****************************************************"
echo "[TASK 1.1] Downloading Promethus"
wget https://github.com/prometheus/prometheus/releases/download/v2.25.2/prometheus-2.25.2.linux-amd64.tar.gz >/dev/null 2>&1

echo "[TASK 1.2] Extracting the Prometheus archive" 
tar -xf prometheus-2.25.2.linux-amd64.tar.gz

echo "[TASK 1.3] Moving the binaries to /usr/local/bin:"
mv prometheus-2.25.2.linux-amd64/prometheus prometheus-2.25.2.linux-amd64/promtool /usr/local/bin

echo "[TASK 1.4] Creating directories for configuration files and other prometheus data"
mkdir /etc/prometheus /var/lib/prometheus

echo "[TASK 1.5] Moving the configuration files to the directory "
mv prometheus-2.25.2.linux-amd64/consoles prometheus-2.25.2.linux-amd64/console_libraries /etc/prometheus

echo "[TASK 1.6] Deleting the leftover files as we do not need them any more" 
rm -r prometheus-2.25.2.linux-amd64*

echo "[TASK 1.7] Configuring Promethus"
cat >> /etc/prometheus/prometheus.yml<<EOF
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus_metrics'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter_metrics'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100','172.16.16.101:9100']
EOF

echo "[TASK 1.8] Creating promethus user without login privilage"
useradd -rs /bin/false prometheus

echo "[TASK 1.9] Changing ownership fils that Prometheus will use"
chown -R prometheus: /etc/prometheus /var/lib/prometheus

echo "[TASK 1.10] Creating systemd service for promethus"
cat >>/etc/systemd/system/prometheus.service<<EOF
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

echo "[TASK 1.11] Reloading systemctl service for the changes"
systemctl daemon-reload

echo "[TASK 1.12] Enable promethus service run on boot"
systemctl enable prometheus

echo "[TASK 1.13] Start promethus service run on boot"
systemctl start prometheus

echo "[TASK 2] Installing and Configuring Grafana"
echo "***************************************************************"

echo "[TASK 2.1] Installing dependencies"
apt-get install -y apt-transport-https software-properties-common wget >/dev/null 2>&1

echo "[TASK 2.2] Adding GPG Key for grafana"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add - >/dev/null 2>&1

echo "[TASK 2.3] Adding the Grafana repository to your APT sources"
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

echo "[TASK 2.4] Refresh your APT cache to update package lists:"
apt-get update -y >/dev/null 2>&1

echo "[TASK 2.5] Installing Grafana"
apt-get install grafana -y >/dev/null 2>&1

echo "[TASK 2.5] Start grafana service run on boot"
systemctl enable --now grafana-server

