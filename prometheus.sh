#!/bin/bash

# Creating Service Users
sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false node_exporter

# Directories for storing Prometheus files and data
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Set the user and group ownership on the new directories to the prometheus user
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Downloading and untar Prometheus
cd ~
wget https://github.com/prometheus/prometheus/releases/download/v2.28.0/prometheus-2.28.0.linux-amd64.tar.gz
sha256sum prometheus-2.28.0.linux-amd64.tar.gz
tar xvf prometheus-2.28.0.linux-amd64.tar.gz

# Copy the two binaries to the /usr/local/bin directory
sudo cp prometheus-2.28.0.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.28.0.linux-amd64/promtool /usr/local/bin/

# Set the user and group ownership on the binaries to the prometheus user created above
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Copy the consoles and console_libraries directories to /etc/prometheus
sudo cp -r prometheus-2.0.0.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.0.0.linux-amd64/console_libraries /etc/prometheus

# Set the user and group ownership on the directories to the prometheus user
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

# Lastly, remove the leftover files from your home directory as they are no longer needed
rm -rf prometheus-2.0.0.linux-amd64.tar.gz prometheus-2.0.0.linux-amd64

# Configuring Prometheus and provide the permissions to prometheus.yml
sudo mv /home/msr/prometheus.yml /etc/prometheus/
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Running Prometheus
sudo -u prometheus /usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

# Creating Prometheus service file to run it as systemd process
sudo mv /home/msr/prometheus.service /etc/systemd/system/

# Starting the Prometheus proces
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl status prometheus
sudo systemctl enable prometheus


