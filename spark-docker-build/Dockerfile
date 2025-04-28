FROM bitnami/spark:3.4.1-debian-11-r0

# ✅ Add Azure Hadoop connector JARs
# (Make sure you download these locally first, I'll show you how below)
ADD libs/hadoop-azure-3.3.2.jar /opt/bitnami/spark/jars/
ADD libs/azure-storage-8.6.6.jar /opt/bitnami/spark/jars/

# ✅ Optional: Preload your Spark application JAR (only if you want)
# ADD target/scala-2.12/spark-dijkstra-azure-assembly-0.1.0-SNAPSHOT.jar /opt/spark-apps/
