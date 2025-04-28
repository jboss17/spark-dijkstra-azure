#!/bin/bash

#SPARK_MASTER_SERVICE="spark-master-service"
#
### Get Spark Master External IP
#SPARK_MASTER_IP=$(kubectl get svc $SPARK_MASTER_SERVICE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
#
#if [ -z "$SPARK_MASTER_IP" ]; then
#  echo "❌ Failed to get Spark Master external IP!"
#  exit 1
#fi
#
#echo "✅ Using Spark Master IP: $SPARK_MASTER_IP"
#
## Optional GitHub Release Link
##JAR_PATH=https://github.com/jboss17/spark-dijkstra-azure/releases/download/v1.0.1/spark-dijkstra-azure-assembly-0.1.0-SNAPSHOT.jar
##JAR_PATH=file:///Users/jboss/IdeaProjects/spark-dijkstra-azure/target/scala-2.12/spark-dijkstra-azure-assembly-0.1.0-SNAPSHOT.jar
#JAR_PATH=local:///opt/spark-apps/spark-dijkstra-azure-assembly-0.1.0-SNAPSHOT.jar
#
#echo "✅ Using JAR: $JAR_PATH"
#
#MAIN_CLASS=com.jboss17.sparkdijkstra.Main
#
#echo "Submitting JAR: $JAR_PATH with Main Class: $MAIN_CLASS"



# Submit the Spark job
spark-submit \
  --class com.jboss17.sparkdijkstra.Main \
  --master spark://spark-worker-vm.rft1b2aherfufd1s223swxltlb.bx.internal.cloudapp.net:7077 \
  target/scala-2.12/spark-dijkstra-azure-assembly-0.1.0-SNAPSHOT.jar \
  data/weighted_graph.txt


#spark-submit \
#  --master spark://"$SPARK_MASTER_IP":7077 \
#  --deploy-mode cluster \
#  --class $MAIN_CLASS \
#  --conf spark.executor.memory=2g \
#  --conf spark.executor.cores=2 \
#  --conf spark.executor.instances=5 \
#  --conf spark.default.parallelism=48 \
#  --conf spark.sql.shuffle.partitions=48 \
#  $JAR_PATH

#  --conf spark.jars=/opt/bitnami/spark/jars/hadoop-azure-3.3.2.jar,/opt/bitnami/spark/jars/azure-storage-8.6.6.jar \