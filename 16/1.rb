module Day16
  class Part1
    DIRECTIONS = {
      north: [-1, 0],
      east: [0, 1],
      south: [1, 0],
      west: [0, -1]
    }

    TURN_POINTS = {
      [:north, :north] => 1,
      [:north, :east] => 1001,
      [:north, :south] => 2001,
      [:north, :west] => 1001,
      [:east, :east] => 1,
      [:east, :north] => 1001,
      [:east, :west] => 2001,
      [:east, :south] => 1001,
      [:south, :south] => 1,
      [:south, :east] => 1001,
      [:south, :north] => 2001,
      [:south, :west] => 1001,
      [:west, :west] => 1,
      [:west, :north] => 1001,
      [:west, :east] => 2001,
      [:west, :south] => 1001
    }

    TO_FOLLOW = {
      north: [:north, :east, :west],
      south: [:south, :east, :west],
      east: [:south, :east, :north],
      west: [:south, :west, :north]
    }

    def initialize(input)
      @board = input.split("\n").map { _1.split('') }
      @start = find_point('S')
      @end = find_point('E')
      @dir = :east
    end

    def call
      queue = [[@start, @dir, Set.new, 0]] # pos, dir, path, points
      min_points = Float::INFINITY
      pos2points = {}

      while pos = queue.shift # BFS
        if pos[0] == @end
          if min_points > pos[-1]
            min_points = pos[-1]
          end
          next
        end

        next if pos2points[pos[0..1]] && pos2points[pos[0..1]] < pos[-1]

        pos2points[pos[0..1]] = pos[-1]

        neighbors(pos[0], pos[1]).each do |coords, dir|
          points = pos[-1] + TURN_POINTS[[dir, pos[1]]]
          next if points > min_points
          next if pos[2].include?(coords)

          queue << [coords, dir, pos[2] + [coords], points]
        end
      end

      min_points
    end

    private

    def neighbors(coords, dir)
      TO_FOLLOW[dir].map do |new_dir|
        dx, dy = DIRECTIONS[new_dir]
        [[coords[0] + dx, coords[1] + dy], new_dir]
      end.filter do |(x, y), _|
        value([x, y]) == '.' || value([x, y]) == 'E'
      end
    end

    def value(coords)
      @board[coords[0]][coords[1]]
    end

    def find_point(symbol)
      (0..@board.size - 1).to_a.product((0..@board[0].size - 1).to_a).detect { |row, col| @board[row][col] == symbol }
    end
  end
end

test_data = <<~DATA
  ###############
  #.......#....E#
  #.#.###.#.###.#
  #.....#.#...#.#
  #.###.#####.#.#
  #.#.#.......#.#
  #.#.#####.###.#
  #...........#.#
  ###.#.#####.#.#
  #...#.....#.#.#
  #.#.#.###.#.#.#
  #.....#...#.#.#
  #.###.#.#.#.#.#
  #S..#.....#...#
  ###############
DATA

fail 'error 1' unless Day16::Part1.new(test_data).call == 7036

test_data = <<~DATA
  #################
  #...#...#...#..E#
  #.#.#.#.#.#.#.#.#
  #.#.#.#...#...#.#
  #.#.#.#.###.#.#.#
  #...#.#.#.....#.#
  #.#.#.#.#.#####.#
  #.#...#.#.#.....#
  #.#.#####.#.###.#
  #.#.#.......#...#
  #.#.###.#####.###
  #.#.#...#.....#.#
  #.#.#.#####.###.#
  #.#.#.........#.#
  #.#.#.#########.#
  #S#.............#
  #################
DATA

fail 'error 2' unless Day16::Part1.new(test_data).call == 11048
