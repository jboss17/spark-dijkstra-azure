package com.jboss17.sparkdijkstra

import org.apache.spark._
import org.apache.spark.graphx._

object Main {

  def main(args: Array[String]): Unit = {

    try {
      val conf = new SparkConf().setAppName("spark-dijkstra-azure")
      //      .setMaster("local[*]")
      val sc = new SparkContext(conf)
      sc.setLogLevel("WARN")

      val inputPath = "data/weighted_graph.txt"
      //    val inputPath = "data/test_graph.txt"
      val outputPath = "/output/dijkstra-results"

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

      System.out.println(">>>>>>>>>> Running Dijkstras")
      val dijkstra = new Dijkstras(graph)

      val output = dijkstra.shortestPath(0L)

      System.out.println(">>>>>>>>>> Dijkstra's Run Successfully!")

      output.coalesce(1).saveAsTextFile(outputPath)

      Thread.sleep(300000)

      sc.stop()

    } catch {
      case e: Throwable =>
        println(s"ERROR CAUGHT: ${e.getMessage}")
        e.printStackTrace()
    }

  }

}
