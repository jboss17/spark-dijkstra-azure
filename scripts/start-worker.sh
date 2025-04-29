#!/bin/bash

# Ensure environment variables like SPARK_HOME are loaded
source ~/.bashrc

# Extract full Master URL from logs, then strip spark:// prefix
MASTER_FULL_URL=$(grep -o 'spark://[^"]*' $SPARK_HOME/logs/spark-*-org.apache.spark.deploy.master.Master-*.out | tail -1)
MASTER_ADDR=${MASTER_FULL_URL#spark://}

# Validate that we actually found a master address
if [ -z "$MASTER_ADDR" ]; then
    echo "❌ Error: Could not find Master address from logs."
    echo "Make sure the Master is running!"
    exit 1
fi

echo "🛠 Starting 1 worker connected to $MASTER_ADDR..."

# Set a dedicated worker directory
export SPARK_WORKER_DIR=$SPARK_HOME/work/worker_1
mkdir -p $SPARK_WORKER_DIR

# Start the worker
$SPARK_HOME/sbin/start-worker.sh $MASTER_ADDR

echo
echo "✅ Done! Worker is now connected to $MASTER_ADDR"
echo



