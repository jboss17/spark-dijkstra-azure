# CSC 4311 Programming Assignment

This repository contains scripts for **Implementing Dijkstra's Algorithm with Apache Spark on Azure VMs**.

It includes installation, configuration, starting, and stopping of Spark components (Master, Workers, and History Server) in a standalone cluster setup.  
The Dijkstra's algorithm runs on a distributed graph stored in a text file, and computes shortest paths efficiently using Apache Spark and GraphX.

---

## 📦 Contents

| Script                                   | Purpose                                                                                             |
|:-----------------------------------------|:----------------------------------------------------------------------------------------------------|
| `install_spark.sh`, `configure_spark.sh` | Install Java, Spark, sbt, configure environment variables, create `spark-defaults.conf` dynamically |
| `start-master.sh`                        | Start Master node                                                                                   |
| `start-worker.sh`                        | Start Worker node                                                                                   |
| `start-history-server.sh`                | Start Spark History Server (for viewing past application logs)                                      |
| `submit.sh`                              | Submit application JAR                                                                              |
| `stop-all.sh`                            | Stop all running Spark services                                                                     |

All scripts are located inside the `scripts/` folder.

May need to run `chmod +x scripts/*.sh` to make scripts executable.

Ensure inbound port rules have been set in your VM for port 8080 (Spark Master UI) and 18080 (Spark History Server UI).

---

## 🌐 Web UIs

Spark Master UI -- http://<your-public-vm-ip>:8080

Spark History Server UI -- http://<your-public-vm-ip>:18080

---

## ⚡ Quick Start

### 1. Connect to VM

```bash
    ssh -i ~/.ssh/your-vm-private-key.pem <username>@<public-IP-of-vm>
```

### 2. Clone Repo

```bash
    git clone https://github.com/jboss17/spark-dijkstra-azure.git
    cd spark-dijkstra-azure
```
### 3. Setup Environment

```bash
    scripts/setup_env.sh
    scripts/configure_spark.sh [azureuser]
```
### 4. Assemble JAR

```bash
    sbt clean assembly
```

### 5. Start Cluster

```bash
    scripts/start-master.sh
    scripts/start-worker.sh
    scripts/start-history-server.sh
```

### 6. Submit Spark Job

```bash
    scripts/submit.sh [starting_node]
```

### 7. Stop Cluster

```bash
    scripts/stop-all.sh
```






