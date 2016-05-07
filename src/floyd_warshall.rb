##
#  Floyd-Warshall
#  Implementation of Floyd-Warshall graphs algorithm
#
#  Copyright 2015, Valerian Saliou
#  Distributed under MIT License
##

require 'deep_clone'


class FloydWarshall
  def initialize(graph)
    @_graph = graph
  end

  def _teta_i(transitive_matrix, i, j, k)
    # teta_i -> W_ij = (W_ij) OR (W_ik AND W_kj)
    # Warning: Ruby cannot perform boolean ops on integers
    #          Thus we convert blocks to boolean operands, then back to numbers

    if (transitive_matrix[i][j] == 1) || \
          (transitive_matrix[i][k] == 1 && transitive_matrix[k][j] == 1)
      return 1
    end

    return 0
  end

  def do
    # Clone object to weaken references (deep clone since it is a 2d array)
    transitive_matrix = DeepClone.clone(@_graph.raw)

    n = transitive_matrix.length

    # Process transitive matrix values
    for k in 0...n
      for i in 0...n
        for j in 0...n
          transitive_matrix[i][j] = _teta_i(transitive_matrix, i, j, k)
        end
      end
    end

    return transitive_matrix
  end
end
