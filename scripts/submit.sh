#!/bin/bash

# Check if starting node ID is provided
if [ -z "$1" ]; then
  echo "❌ Error: You must provide a starting node ID."
  echo "Usage: ./submit.sh <starting-node-id>"
  exit 1
fi

# Starting node ID from the first argument
STARTING_NODE_ID=$1

# Submit the Spark job
spark-submit \
  --class com.jboss17.sparkdijkstra.Main \
  --master spark://$MASTER_ADDR:7077 \
  target/scala-2.12/spark-dijkstra-azure-assembly-0.1.0-SNAPSHOT.jar \
  $STARTING_NODE_ID

