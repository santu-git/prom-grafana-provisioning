#!/bin/bash
# All command will be run as root

echo "[TASK 1] Installing and Configuring Promethus Server"
echo "****************************************************"
echo "[TASK 1.1] Download Promethus"
wget https://github.com/prometheus/prometheus/releases/download/v2.25.2/prometheus-2.25.2.linux-amd64.tar.gz

echo "[TASK 1.2] Extract the Prometheus archive" 
tar -xf prometheus-2.25.2.linux-amd64.tar.gz

echo "[TASK 1.3] Move the binaries to /usr/local/bin:"
mv prometheus-2.25.2.linux-amd64/prometheus prometheus-2.25.2.linux-amd64/promtool /usr/local/bin

echo "[TASK 1.4] Create directories for configuration files and other prometheus data"
mkdir /etc/prometheus /var/lib/prometheus

echo "[TASK 1.5] Move the configuration files to the directory "
mv prometheus-2.25.2.linux-amd64/consoles prometheus-2.25.2.linux-amd64/console_libraries /etc/prometheus

echo "[TASK 1.6] Delete the leftover files as we do not need them any more" 
rm -r prometheus-2.25.2.linux-amd64*

