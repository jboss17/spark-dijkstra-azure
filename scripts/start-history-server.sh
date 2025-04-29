#!/bin/bash

# Ensure SPARK_HOME is available
source ~/.bashrc

# Path to the event log directory (should match what's in spark-defaults.conf)
USERNAME=${1:-$(whoami)}
EVENT_LOG_DIR="/home/$USERNAME/tmp/spark-events"

# Check if the event log directory exists
if [ ! -d "$EVENT_LOG_DIR" ]; then
    echo "⚠️  Warning: Event log directory $EVENT_LOG_DIR does not exist."
    echo "ℹ️  Creating it now..."
    mkdir -p "$EVENT_LOG_DIR"
    echo "✅ Created $EVENT_LOG_DIR"
fi

# Start the Spark History Server
echo "🚀 Starting Spark History Server..."
$SPARK_HOME/sbin/start-history-server.sh

# Get public IP to print web access info
VM_IP=$(curl -s ifconfig.me)

echo
echo "✅ Spark History Server started!"
echo "🌐 Access it at: http://$VM_IP:18080"
echo
