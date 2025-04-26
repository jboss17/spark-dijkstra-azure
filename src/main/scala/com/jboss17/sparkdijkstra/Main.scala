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

      val raw = sc.textFile(inputPath)

      println(s"Loaded ${raw.count()} lines from $inputPath")

      val data = raw.zipWithIndex().filter { case (_, idx) => idx != 0 }.map(_._1)

      val edges = data.flatMap { line =>
        val Array(u, v, w) = line.split("\\s+").map(_.toLong)
        Seq(
          Edge(u, v, w.toDouble),
          Edge(v, u, w.toDouble)
        )
      }

      val vertices = edges.flatMap(e => Seq(e.srcId, e.dstId)).distinct().map(id => (id, s"Node $id"))

      val graph = Graph(vertices, edges)

      val dijkstra = new Dijkstras(graph)

      val output = dijkstra.shortestPath(0L)

      output.coalesce(1).saveAsTextFile(outputPath)

      sc.stop()

    } catch {
      case e: Throwable =>
        println(s"ERROR CAUGHT: ${e.getMessage}")
        e.printStackTrace()
    }

  }

}
