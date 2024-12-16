require_relative '1'

module Day16
  class Part2 < Part1

    def initialize(input)
      super
      @length = Day16::Part1.new(input).call
    end

    def call
      queue = [[@start, @dir, Set.new, 0]] # pos, dir, path, points
      pos2points = {}
      tiles = Set.new([@start])

      while pos = queue.shift # BFS
        if pos[0] == @end
          if pos[-1] == @length
            tiles += pos[2]
          end

          next
        end

        next if pos2points[pos[0..1]] && pos2points[pos[0..1]] < pos[-1]
        pos2points[pos[0..1]] = pos[-1]

        neighbors(pos[0], pos[1]).each do |coords, dir|
          points = pos[-1] + TURN_POINTS[[dir, pos[1]]]
          next if points > @length
          next if pos[2].include?(coords)

          queue << [coords, dir, pos[2] + [coords], points]
        end
      end

      tiles.count
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
fail 'error 1' unless Day16::Part2.new(test_data).call == 45

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

fail 'error 2' unless Day16::Part2.new(test_data).call == 64
