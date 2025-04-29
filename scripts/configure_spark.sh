#!/bin/bash

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