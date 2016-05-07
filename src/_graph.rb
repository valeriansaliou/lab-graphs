##
#  Graph (Abstraction)
#  Implementation of Floyd-Warshall graphs algorithm
#
#  Copyright 2015, Valerian Saliou
#  Distributed under MIT License
##


class GraphAbstraction
  def initialize(nodes, arcs, fill_mode='zero', is_directed=false, is_weighed=false)
    @_nodes = []
    @_arcs = []

    # Storage mode (zero or infinity)
    @_fill_mode = fill_mode

    # Direction mode (oriented or not)
    @_is_directed = is_directed

    # Weight mode
    @_is_weighed = is_weighed

    # Generated cache matrix (avoids extra-cycles on later node deep search)
    # Format:
    # [y1=[x1,x2], y2=[x1,x2]] where n = len({x}) <=> len({y})
    @_adjacency_matrix = []

    _pre_heat_cache!(nodes, arcs)
  end

  def _pre_heat_cache!(nodes, arcs)
    # Prepare an empty matrix
    nodes.each { |node|
      add_node!(node)
    }

    # Populate matrix with arcs / weights
    arcs.each { |arc|
      arc_weight = if weighed? then arc[2] else 1 end

      add_arc!(arc[0], arc[1], arc_weight)
    }
  end

  def _fill_matrix!(x, y)
    if fill_mode == 'infinity'
      @_adjacency_matrix[y][x] = Float::INFINITY
    else
      @_adjacency_matrix[y][x] = 0
    end
  end

  def _check_node_connexion(arc_value)
    if (fill_mode == 'infinity' && arc_value == Float::INFINITY) || \
        (fill_mode != 'infinity' && arc_value == 0)
      return nil
    end

    return arc_value
  end

  def _check_node_degree(arc_value)
    if _check_node_connexion(arc_value) != nil
      return 1
    end

    return 0
  end

  def _index(node)
    return @_nodes.index(node)
  end

  def add_node!(node)
    # Add to node list
    @_nodes.push(node)

    count_total = @_adjacency_matrix.length
    node_index = _index(node)

    # Add to adjacency matrix (Y)
    @_adjacency_matrix[node_index] = []

    (0..count_total).each { |node_x|
      _fill_matrix!(node_x, node_index)
    }

    # Refine existing adjacency rows
    (0..node_index).each { |node_y|
      _fill_matrix!(node_index, node_y)
    }
  end

  def add_arc!(node_from, node_to, weight)
    # Add to arc list
    @_arcs.push([node_from, node_to, weight])

    # Add to adjacency matrix (default directed: ->)
    @_adjacency_matrix[_index(node_from)][_index(node_to)] = weight

    if directed? == false
      # Non-directed (mirror: -> in reverse direction: <-)
      @_adjacency_matrix[_index(node_to)][_index(node_from)] = weight
    end
  end

  def node?(node)
    return (@_adjacency_matrix[_index(node)].length > 0) && true
  end

  def arc?(node_from, node_to)
    if fill_mode == 'infinity'
      return (@_adjacency_matrix[_index(node_from)][_index(node_to)] != Float::INFINITY) && true
    else
      return (@_adjacency_matrix[_index(node_from)][_index(node_to)] != 0) && true
    end
  end

  def arc_weight(node_from, node_to)
    return @_adjacency_matrix[_index(node_from)][_index(node_to)]
  end

  def node_degree(node)
    if directed? == true
      return (node_degree_in(node) + node_degree_out(node))
    end

    # One direction is good to go here (non-directed/mirror case)
    return node_degree_out(node)
  end

  def node_degree_in(node)
    node_x = (node - 1)

    # Count number of arcs going in node
    @_adjacency_matrix.reduce { |cur_row_adjacency|
      return _check_node_degree(cur_row_adjacency[node_x])
    }
  end

  def node_degree_out(node)
    # Count number of arcs going out of node
    return @_adjacency_matrix[_index(node)].reduce { |arc_value|
      return _check_node_degree(arc_value)
    }
  end

  def node_next(node)
    # Map nodes connected to given node (out direction)
    @_adjacency_matrix[_index(node)].each_with_index { |value, index|
      if _check_node_connexion(value) != nil
        yield @_nodes[index]
      end
    }
  end

  def node_previous(node)
    node_x = (node - 1)

    # Map nodes connected to given node (in direction)
    @_adjacency_matrix.each { |cur_row_adjacency|
      if _check_node_connexion(cur_row_adjacency[node_x]) != nil
        yield @_nodes[node_x]
      end
    }
  end

  def raw
    # Returns raw internals (adjacency matrix)
    return @_adjacency_matrix
  end

  def nodes
    return @_nodes
  end

  def arcs
    return @_arcs
  end

  def directed?
    return @_is_directed
  end

  def weighed?
    return @_is_weighed
  end

  def fill_mode
    return @_fill_mode
  end
end
