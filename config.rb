##
#  Configuration data provisionning
#
#  Copyright 2015, Valerian Saliou
#  Distributed under MIT License
##

BASE_PATH = File.expand_path(File.dirname(__FILE__))


module Config
  # Data format:
  #   Graph[node_name] => {
  #     :nodes => [list_nodes],
  #     :arcs => [(node, node, weight)]
  #   }

  GRAPHS = [
    {
      :graph   => {
        :nodes => [1, 2, 3, 4],

        :arcs  => [
          [1, 2, 7],
          [1, 1, 2],
          [2, 3, 14],
          [3, 4, 2],
          [4, 1, 32]
        ],

        :fill_mode   => 'zero',
        :is_directed => false,
        :is_weighed  => true
      },

      :result => [
        [2, 7, 0, 32],
        [7, 0, 14, 0],
        [0, 14, 0, 2],
        [32, 0, 2, 0]
      ]
    }
  ]

  WARSHALL = [
    {
      # Data from: \
      #  http://people.cs.pitt.edu/~adamlee/courses/cs0441/lectures/ \
      #    lecture27-closures.pdf

      :graph   => {
        :nodes => [1, 2, 3],

        :arcs  => [
          [1, 1],
          [1, 3],
          [2, 2],
          [3, 1],
          [3, 2]
        ],

        :fill_mode   => 'zero',
        :is_directed => true,
        :is_weighed  => false
      },

      :result => [
        [1, 1, 1],
        [0, 1, 0],
        [1, 1, 1]
      ]
    },

    {
      # Data from: \
      #   http://www.dartmouth.edu/~matc/DiscreteMath/V.6.pdf

      # Warning: mistake spotted in their doc: T_34 is 0 for them, but \
      #   1 in reality, since V(3) is adjacent to V(4) (through V(1))
      # It has been fixed in the result matrix here (0 set to 1)

      :graph   => {
        :nodes => [1, 2, 3, 4],

        :arcs  => [
          [1, 2],
          [1, 4],
          [2, 1],
          [2, 3],
          [3, 1]
        ],

        :fill_mode   => 'zero',
        :is_directed => true,
        :is_weighed  => false
      },

      :result => [
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [1, 1, 1, 1],
        [0, 0, 0, 0]
      ]
    },

    {
      # Data from: \
      #   http://www.info2.uqam.ca/~inf1130/documents/FermetureMatrices.pdf

      :graph   => {
        :nodes => [1, 2, 3, 4, 5, 6],

        :arcs  => [
          [1, 2],
          [1, 4],
          [3, 2],
          [3, 5],
          [4, 6],
          [5, 3],
          [5, 4]
        ],

        :fill_mode   => 'zero',
        :is_directed => true,
        :is_weighed  => false
      },

      :result => [
        [0, 1, 0, 1, 0, 1],
        [0, 0, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 1],
        [0, 0, 0, 0, 0, 1],
        [0, 1, 1, 1, 1, 1],
        [0, 0, 0, 0, 0, 0]
      ]
    }
  ]

  DIJKSTRA = {
    # Data from: \
    #   https://upload.wikimedia.org/wikipedia/commons/ \
    #     5/57/Dijkstra_Animation.gif

    :graph   => {
      :nodes => [1, 2, 3, 4, 5, 6],

      :arcs  => [
        [1, 2, 7],
        [2, 4, 15],
        [4, 5, 6],
        [5, 6, 9],
        [6, 1, 14],
        [1, 3, 9],
        [2, 3, 10],
        [4, 3, 11],
        [6, 3, 2]
      ],

      :fill_mode   => 'infinity',
      :is_directed => false,
      :is_weighed  => true
    },

    :sources => [
      {
        # Will process shortest paths to all nodes starting from node 1

        :source_node => 1,

        :result_distance => {
          1 => 0,
          2 => 7,
          3 => 9,
          4 => 20,
          5 => 20,
          6 => 11
        },

        :result_previous => {
          1 => nil,
          2 => 1,
          3 => 1,
          4 => 3,
          5 => 6,
          6 => 3
        }
      },

      {
        # Will process shortest paths to all nodes starting from node 1

        :source_node => 3,

        :result_distance => {
          1 => 9,
          2 => 10,
          3 => 0,
          4 => 11,
          5 => 11,
          6 => 2
        },

        :result_previous => {
          1 => 3,
          2 => 3,
          3 => nil,
          4 => 3,
          5 => 6,
          6 => 3
        }
      },

      {
        # Will process shortest paths to all nodes starting from node 1

        :source_node  =>  5,

        :result_distance  =>  {
          1 => 14,
          2 => 7,
          3 => 9,
          4 => 6,
          5 => 0,
          6 => 9
        },

        :result_previous  =>  {
          1 => 2,
          2 => 1,
          3 => 1,
          4 => 5,
          5 => nil,
          6 => 5
        }
      }
    ]
  }

  ROUTING  = [
    {
      :graph   => {
        :nodes => [
          '10.0.1.0/24',
          '10.0.2.0/24',
          '10.0.3.0/24',
          '10.0.4.0/24',
          '10.0.5.0/24'
        ],

        :arcs  => [
          ['10.0.1.0/24', '10.0.2.0/24', 10],
          ['10.0.1.0/24', '10.0.4.0/24', 5],
          ['10.0.2.0/24', '10.0.3.0/24', 5],
          ['10.0.2.0/24', '10.0.4.0/24', 5],
          ['10.0.2.0/24', '10.0.5.0/24', 10],
          ['10.0.4.0/24', '10.0.5.0/24', 20]
        ],

        :fill_mode   => 'zero',
        :is_directed => false,
        :is_weighed  => true
      },

      :result => [
        [0 , 10, 15, 5 , 20],
        [10, 0 , 5 , 5 , 10],
        [15, 5 , 0 , 10, 15],
        [5 , 5 , 10, 0 , 15],
        [20, 10, 15, 15, 0 ]
      ]
    }
  ]
end
