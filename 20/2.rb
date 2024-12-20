require_relative '1'

module Day20
  class Part2 < Part1

    def call(&check)
      count = 0

      walkable.each_with_index do |point1, i|
        walkable[i + 1...].each do |point2|
          manhattan_distance = (point1[0] - point2[0]).abs + (point1[1] - point2[1]).abs
          if manhattan_distance <= 20 &&
            check.((@distances[point1] - @distances[point2]).abs - manhattan_distance)
            count += 1
          end
        end
      end

      count
    end

    private

    def walkable
      @points ||= begin
        points = []
        @board.each_with_index do |line, row|
          line.each_with_index do |e, col|
            points << [row, col] if e != '#'
          end
        end
        points
      end
    end
  end
end

test_data = <<~DATA
  ###############
  #...#...#.....#
  #.#.#.#.#.###.#
  #S#...#.#.#...#
  #######.#.#.###
  #######.#.#...#
  #######.#.###.#
  ###..E#...#...#
  ###.#######.###
  #...###...#...#
  #.#####.#.###.#
  #.#...#.#.#...#
  #.#.#.#.#.#.###
  #...#...#...###
  ###############
DATA

solver = Day20::Part2.new(test_data)
fail 'error' unless solver.call { _1 == 50 } == 32
fail 'error' unless solver.call { _1 == 52 } == 31
fail 'error' unless solver.call { _1 == 54 } == 29
fail 'error' unless solver.call { _1 == 56 } == 39
fail 'error' unless solver.call { _1 == 58 } == 25
fail 'error' unless solver.call { _1 == 60 } == 23
fail 'error' unless solver.call { _1 == 62 } == 20
fail 'error' unless solver.call { _1 == 64 } == 19
fail 'error' unless solver.call { _1 == 66 } == 12
fail 'error' unless solver.call { _1 == 68 } == 14
fail 'error' unless solver.call { _1 == 70 } == 12
fail 'error' unless solver.call { _1 == 72 } == 22
fail 'error' unless solver.call { _1 == 74 } == 4
fail 'error' unless solver.call { _1 == 76 } == 3
