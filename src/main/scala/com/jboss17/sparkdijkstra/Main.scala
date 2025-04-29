package com.jboss17.sparkdijkstra

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.graphx.{Edge, Graph}

object Main {

  def main(args: Array[String]): Unit = {

    if (args.length < 1) {
      System.err.println("Usage: Main <starting-node-id>")
      System.exit(1)
    }

    val startingNodeId = args(0).toLong

    val conf = new SparkConf().setAppName("spark-dijkstra-azure")
    val sc = new SparkContext(conf)
    sc.setLogLevel("WARN")

    val inputPath = "data/weighted_graph.txt"

    // === Dynamically create outputPath with timestamp ===
    val now = LocalDateTime.now()
    val formatter = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")
    val timestamp = now.format(formatter)
    val outputPath = s"file:///home/jboss17/spark-dijkstra-azure/output/dijkstra-results-$timestamp"

    System.out.println(">>>>>>>>>> Reading Data")
    val raw = sc.textFile(inputPath)

    System.out.println(">>>>>>>>>> Data Read")
    val data = raw.zipWithIndex().filter { case (_, idx) => idx != 0 }.map(_._1)

    System.out.println(">>>>>>>>>> Initializing Graph")
    val edges = data.flatMap { line =>
      val Array(u, v, w) = line.split("\\s+").map(_.toLong)
      Seq(
        Edge(u, v, w.toDouble),
        Edge(v, u, w.toDouble)
      )
    }

    val vertices = edges.flatMap(e => Seq(e.srcId, e.dstId)).distinct().map(id => (id, s"Node $id"))
    val graph = Graph(vertices, edges)

    System.out.println(">>>>>>>>>> Graph Initialized!!")

    System.out.println(s">>>>>>>>>> Running Dijkstra's from node $startingNodeId")
    val dijkstra = new Dijkstras(graph)

    val output = dijkstra.shortestPath(startingNodeId)

    System.out.println(">>>>>>>>>> Dijkstra's Run Successfully!")

    output.coalesce(1).saveAsTextFile(outputPath)

    System.out.println(s">>>>>>>>>> Output written to $outputPath")

    sc.stop()
  }
}

