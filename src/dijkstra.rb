##
#  Dijkstra
#  Implementation of Dijkstra graphs algorithm
#
#  Copyright 2015, Valerian Saliou
#  Distributed under MIT License
##


class Dijkstra
  def initialize(graph)
    @_graph = graph
  end

  def _find_node_least_distance(nodes, distance)
    node_least_distance = nil

    nodes.each { |node|
      if node_least_distance == nil || distance[node] < node_least_distance
        node_least_distance = node
      end
    }

    return node_least_distance
  end

  def do(source)
    shortest_path_matrix = []

    nodes_heap = []
    distance = {}
    previous = {}

    # Build the initial processing heap
    @_graph.nodes.each { |node|
      distance[node] = Float::INFINITY
      previous[node] = nil

      nodes_heap.push(node)
    }

    distance[source] = 0

    while nodes_heap.length > 0 do
      # Pick the node that has the least distance
      node_least_distance = _find_node_least_distance(nodes_heap, distance)
      nodes_heap.delete(node_least_distance)

      # Find shortest path in neighbors of `node_least_distance`
      @_graph.node_next(node_least_distance) { |node|
        node_distance = @_graph.arc_weight(node_least_distance, node)

        # Normalize infinity to zero here
        least_distance = distance[node_least_distance]

        if least_distance == Float::INFINITY
          least_distance = 0
        end

        # Process current aggregated weight
        current_weight = least_distance + node_distance

        if current_weight < distance[node]
          distance[node] = current_weight
          previous[node] = node_least_distance
        end
      }
    end

    return {
      :distance => distance,
      :previous => previous
    }
  end
end
