# CSC 4311 Programming Assignment

This repository contains scripts for **Implementing Dijkstra's Algorithm with Apache Spark on Azure VMs**.

It includes installation, configuration, starting, and stopping of Spark components (Master, Workers, and History Server) in a standalone cluster setup.  
The Dijkstra's algorithm runs on a distributed graph stored in a text file, and computes shortest paths efficiently using Apache Spark and GraphX.

---

## 📦 Contents

| Script                    | Purpose                                                                                        |
|:--------------------------|:-----------------------------------------------------------------------------------------------|
| `setup_spark.sh`          | Install Java, Spark, configure environment variables, create `spark-defaults.conf` dynamically |
| `start-master.sh`         | Start Spark Master node                                                                        |
| `start-worker.sh`         | Start one or more Spark Worker nodes                                                           |
| `start-history-server.sh` | Start Spark History Server (for viewing past application logs)                                 |
| `submit.sh`               | Submit application JAR                                                                         |
| `stop-all.sh`             | Stop all running Spark services                                                                |

All scripts are located inside the `scripts/` folder.

May need to run `chmod +x scripts/*.sh` to make scripts executable.

Ensure inbound port rules have been set in your VM for port 8080 (Spark Master UI) and 18080 (Spark History Server UI).

---

## 🌐 Web UIs

Spark Master UI -- http://<your-public-vm-ip>:8080

Spark History Server UI -- http://<your-public-vm-ip>:18080

---

## ⚡ Quick Start

### 1. Connect to your VM

```bash
    ssh -i ~/.ssh/your-vm-private-key.pem <username>@<public-IP-of-vm>
```

### 2. Clone the repository

```bash
    git clone https://github.com/jboss17/spark-dijkstra-azure.git
    cd spark-dijkstra-azure/scripts
```
### 3. Install Spark

```bash
    ./setup_spark.sh [username]
```

Example:

```bash
    ./setup_spark.sh azureuser
```

### 4. Start Cluster

```bash
    ./start-master-simple.sh
    ./start-worker-simple.sh [number_of_workers]   # default is 1
    ./start-history-server.sh
```

### 5. Submit Spark Job

```bash
    ./submit [starting_node]
```

### 6. Stop Cluster

```bash
    ./stop-all.sh
```






