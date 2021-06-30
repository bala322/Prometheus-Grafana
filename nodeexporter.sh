#!/bin/bash
# Author: Raghav Shetty
# Description: This script will install the node exporter and start the service in the particular vm
# Creation Date and Time: 30-06-2021 and 3:00 pm
# Note: If you want to copy this script(scp filename username@ipaddres:/directory path) to other vm don't forgot to copy /home/msr/node_exporter.service also 
# Note: After creation of this service just go the vm where your prometheus lies and include the nodeexporter scarp th creation of this service just go the vm where your prometheus lies and include the nodeexporter scarp there

# Downloading Node Exporter and untar the zip folder
cd ~
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
sha256sum node_exporter-0.15.1.linux-amd64.tar.gz
sudo tar xvf node_exporter-0.15.1.linux-amd64.tar.gz

# Copy the binary to the /usr/local/bin directory and set the user and group ownership to the node_exporter user that you created in above step and remove the downloaded tar files
sudo cp node_exporter-0.15.1.linux-amd64/node_exporter /usr/local/bin
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo rm -rf node_exporter-0.15.1.linux-amd64.tar.gz node_exporter-0.15.1.linux-amd64

# Running Node Exporter
sudo mv /home/msr/node_exporter.service /etc/systemd/system/

# Run the Node Exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter
sudo systemctl enable node_exporter

echo "After the completion of the node exporter installation, go to prometheus.yml file and the related node_exporter scrapr to it and resatrt the prometheus afterwards."
