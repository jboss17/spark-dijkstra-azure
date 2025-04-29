#!/bin/bash

# Ensure environment variables like SPARK_HOME are loaded
source ~/.bashrc

# Start Spark Master
$SPARK_HOME/sbin/start-master.sh

# Wait a few seconds for Master to initialize and write logs
sleep 5

# (Optional) Grab public IP for Web UI
VM_IP=$(curl -s ifconfig.me)

# Print information
echo
echo "✅ Done! Spark Master should be running."
echo "🌐 Spark Master Web UI: http://$VM_IP:8080"
echo
