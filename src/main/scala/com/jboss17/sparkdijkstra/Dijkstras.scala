package com.jboss17.sparkdijkstra

import org.apache.spark.graphx._
import org.apache.spark.rdd.RDD

class Dijkstras(graph: Graph[String, Double]) {

  def shortestPath(sourceId: VertexId): RDD[String] = {

    val initialGraph = graph.mapVertices((id, _) =>
      if (id == sourceId) 0.0 else Double.PositiveInfinity
    )

    val sssp = initialGraph.pregel(Double.PositiveInfinity)(
      (_, currentDist, newDist) => math.min(currentDist, newDist),
      triplet => {
        if (triplet.srcAttr + triplet.attr < triplet.dstAttr) {
          Iterator((triplet.dstId, triplet.srcAttr + triplet.attr))
        } else {
          Iterator.empty
        }
      },
      (a, b) => math.min(a, b)
    )

    graph.vertices
      .leftJoin(sssp.vertices) {
        case (_, label, maybeDist) => (label, maybeDist.getOrElse(Double.PositiveInfinity))
      }
      .map(identity) // converts to regular RDD
      .sortBy(_._1)
      .map { case (_, (label, dist)) =>
        s"$label: ${if (dist.isPosInfinity) "INF" else f"$dist%.2f"}"
      }

  }
}