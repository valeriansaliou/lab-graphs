##
#  Routing
#  Implementation of a graph-based routing algorithm
#
#  Copyright 2015, Valerian Saliou
#  Distributed under MIT License
##

require 'deep_clone'


class Routing
  def initialize(graph)
    @_graph = graph
  end

  def do
    # Clone object to weaken references (deep clone since it is a 2d array)
    transitive_matrix = DeepClone.clone(@_graph.raw)

    n = transitive_matrix.length

    # Process routing matrix values
    for k in 0...n
      for i in 0...n
        for j in 0...n
          # Not self (self weight is zero)
          if transitive_matrix[i][k] != 0 && \
                transitive_matrix[k][j] != 0 && (i != j)
            # Does this path seems better than the already-stored one?
            if (transitive_matrix[i][k] + transitive_matrix[k][j] < \
                  transitive_matrix[i][j]) || (transitive_matrix[i][j] == 0)
              transitive_matrix[i][j] = transitive_matrix[i][k] + \
                                          transitive_matrix[k][j]
            end
          end
        end
      end
    end

    return transitive_matrix
  end
end
