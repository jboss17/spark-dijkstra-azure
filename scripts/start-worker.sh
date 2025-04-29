#!/bin/bash

# Ensure environment variables like SPARK_HOME are loaded
source ~/.bashrc

# Extract full Master URL from logs, then strip spark:// prefix
MASTER_FULL_URL=$(grep -o 'spark://[^"]*' $SPARK_HOME/logs/spark-*-org.apache.spark.deploy.master.Master-*.out | tail -1)
MASTER_ADDR=${MASTER_FULL_URL#spark://}

# Default number of workers to 1 if not specified
NUM_WORKERS=${1:-1}

# Validate that we actually found a master address
if [ -z "$MASTER_ADDR" ]; then
    echo "❌ Error: Could not find Master address from logs."
    echo "Make sure the Master is running!"
    exit 1
fi

echo "🛠 Starting $NUM_WORKERS worker(s) connected to $MASTER_ADDR..."

# Loop to start the requested number of workers
for ((i=1; i<=NUM_WORKERS; i++)); do
    echo "🚀 Starting worker #$i..."

    # Set unique WORKER ID and LOG DIR per worker
    export SPARK_WORKER_DIR=$SPARK_HOME/work/worker_$i
    mkdir -p $SPARK_WORKER_DIR

    $SPARK_HOME/sbin/start-worker.sh $MASTER_ADDR
    sleep 1
done

echo
echo "✅ Done! $NUM_WORKERS worker(s) are now connected to $MASTER_ADDR"
echo


