#!/bin/bash
# All command will be run as root

echo "[TASK 1] Downloading Promethus node_exporter"
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz >/dev/null 2>&1

echo "[TASK 2] Extracting the Prometheus node_exporter archive" 
tar -xf node_exporter-1.1.2.linux-amd64.tar.gz

echo "[TASK 2] Moving the node_exporter binary to /usr/local/bin:"
mv node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin

echo "[TASK 3] Deleting the leftover files as we do not need them any more" 
rm -r node_exporter-1.1.2.linux-amd64*

echo "[TASK 4] Creating node_exporter user without login privilage"
sudo useradd -rs /bin/false node_exporter

echo "[TASK 5] Creating systemd service for node_exporter"
cat >>/etc/systemd/system/node_exporter.service<<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

echo "[TASK 6] Reloading systemctl service for the changes"
systemctl daemon-reload

echo "[TASK 7] Enable node_exporter service run on boot"
systemctl enable node_exporter

echo "[TASK 1.13] Start node_exporter service run on boot"
systemctl start node_exporter