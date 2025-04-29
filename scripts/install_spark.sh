#!/bin/bash

# === Part 1: Install Java and Curl ===
echo "📦 Updating system and installing Java + Curl..."
sudo apt update
sudo apt install -y openjdk-11-jdk wget tar curl

# === Part 2: Download and Install Spark ===
echo "⬇️ Downloading Spark 3.4.1..."
wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz

echo "🛠 Extracting Spark..."
tar xvf spark-3.4.1-bin-hadoop3.tgz
mv spark-3.4.1-bin-hadoop3 spark

# === Part 3: Set Environment Variables ===
echo "🔧 Setting SPARK_HOME and PATH..."
if ! grep -q "export SPARK_HOME=~/spark" ~/.bashrc; then
    echo 'export SPARK_HOME=~/spark' >> ~/.bashrc
    echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >> ~/.bashrc
fi

# Load new environment variables
source ~/.bashrc
