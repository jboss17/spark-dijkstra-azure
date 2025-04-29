#!/bin/bash

# Ensure SPARK_HOME is available
source ~/.bashrc

echo "🛑 Stopping Spark Workers..."
$SPARK_HOME/sbin/stop-worker.sh

echo "🛑 Stopping Spark Master..."
$SPARK_HOME/sbin/stop-master.sh

echo "🛑 Stopping Spark History Server..."
$SPARK_HOME/sbin/stop-history-server.sh

echo
echo "✅ All Spark services have been stopped."
echo
