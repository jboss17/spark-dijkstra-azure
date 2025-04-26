#!/bin/bash

SPARK_MASTER_SERVICE="spark-master-service"
TARGET_JAR_PATTERN="spark-dijkstra-azure"

# Get Spark Master External IP
SPARK_MASTER_IP=$(kubectl get svc $SPARK_MASTER_SERVICE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$SPARK_MASTER_IP" ]; then
  echo "❌ Failed to get Spark Master external IP!"
  exit 1
fi

echo "✅ Using Spark Master IP: $SPARK_MASTER_IP"

# Auto-find JAR inside the Pod
JAR_FILE=$(kubectl exec spark-master-556cff68fd-hzz6r -- sh -c "cd /opt/bitnami/spark && ls *.jar | grep '$TARGET_JAR_PATTERN' | head -n 1")

if [ -z "$JAR_FILE" ]; then
  echo "❌ Could not find any JAR matching '$TARGET_JAR_PATTERN'"
  exit 1
fi

# JAR_PATH="/opt/bitnami/spark/${JAR_FILE}"
JAR_PATH="target/scala-2.12/spark-dijkstra-azure-assembly-0.1.0-SNAPSHOT.jar"

echo "✅ Using JAR: $JAR_PATH"

# Define Main Class
MAIN_CLASS=com.jboss17.sparkdijkstra.Main

echo "Submitting JAR: $JAR_PATH with Main Class: $MAIN_CLASS"

# Submit the Spark job
spark-submit \
  --master k8s://https://spark-clus-spark-k8s-jboss1-b9f1b8-z839kips.hcp.eastus.azmk8s.io \
  --deploy-mode cluster \
  --name spark-dijkstra-job \
  --class $MAIN_CLASS \
  --conf spark.executor.instances=2 \
  --conf spark.kubernetes.container.image=bitnami/spark:3.4.1 \
  --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
  $JAR_PATH

  # Standalone Mode spark://$SPARK_MASTER_IP:7077
  # Spark does not read YAML files in this command --> --master k8s://https://<your-k8s-api-server-endpoint> \
  #   - Spark itself directly creates Kubernetes Pods (Driver + Executors) via the Kubernetes API
  #   - As a result, must specify Docker image to use to launch Driver/Executor pods

  # Spark defaults to 1 executor -->   --conf spark.executor.instances=2 \
  #   - specify for true parallelism