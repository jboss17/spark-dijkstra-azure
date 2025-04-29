#!/bin/bash

# === Part 1: Install Java and Curl ===
echo "📦 Updating system and installing Java + Curl..."
sudo apt update
sudo apt install -y openjdk-11-jdk wget tar curl gnupg

# === Part 2: Download and Install Spark ===
echo "⬇️ Downloading Spark 3.4.1..."
wget https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz

echo "🛠 Extracting Spark..."
tar xvf spark-3.4.1-bin-hadoop3.tgz
mv spark-3.4.1-bin-hadoop3 ~/spark

echo "🧹 Cleaning up downloaded archive..."
rm spark-3.4.1-bin-hadoop3.tgz

# === Part 3: Set Environment Variables ===
echo "🔧 Setting SPARK_HOME and PATH..."
if ! grep -q "export SPARK_HOME=~/spark" ~/.bashrc; then
    echo "export SPARK_HOME=~/spark" >> ~/.bashrc
    echo "export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin" >> ~/.bashrc
fi

# Load new environment variables for this session
#export SPARK_HOME=~/spark
#export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
#source ~/.bashrc

# === Part 4: Install SBT ===
echo "📦 Installing SBT (Scala Build Tool)..."

# Add SBT repo and key
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x99E82A75642AC823" | sudo apt-key add -
sudo apt update
sudo apt install -y sbt

echo
echo "✅ Spark and SBT installation complete!"
echo
echo "ℹ️ You can now run 'sbt clean assembly' to build your Spark application."
echo

# Load new environment variables
source ~/.bashrc
