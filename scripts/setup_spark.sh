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

# Also export it in this script context so we can use it immediately
export SPARK_HOME=~/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin


# Load new environment variables
source ~/.bashrc

# === Part 4: Create spark-defaults.conf dynamically ===
# Get username from first argument, or default to current system user
USERNAME=${1:-$(whoami)}

# Event log directory
EVENT_LOG_DIR="/home/$USERNAME/tmp/spark-events"
mkdir -p "$EVENT_LOG_DIR"

# spark-defaults.conf path
SPARK_DEFAULTS_CONF="$SPARK_HOME/conf/spark-defaults.conf"

# Backup if exists
if [ -f "$SPARK_DEFAULTS_CONF" ]; then
    echo "📄 Backing up existing spark-defaults.conf to spark-defaults.conf.bak"
    cp "$SPARK_DEFAULTS_CONF" "$SPARK_DEFAULTS_CONF.bak"
fi

# Create new spark-defaults.conf
cat <<EOF > "$SPARK_DEFAULTS_CONF"
spark.eventLog.enabled             true
spark.eventLog.dir                 file://$EVENT_LOG_DIR/
spark.history.fs.logDirectory      file://$EVENT_LOG_DIR/
spark.history.ui.address           0.0.0.0
EOF

# === Done ===
echo
echo "✅ Spark installation and configuration complete!"
echo "✅ SPARK_HOME set to $SPARK_HOME"
echo "✅ spark-defaults.conf created at $SPARK_DEFAULTS_CONF"
echo "✅ Event log directory created at $EVENT_LOG_DIR"
echo
echo "ℹ️ Please run 'source ~/.bashrc' if you open a new terminal to load environment variables."
echo
