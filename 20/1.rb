module Day20
  class Part1
    def initialize(input)
      parse(input)
      dijkstra # It is too much for this task, but I saw it too late
    end

    def call(&check)
      obstacles.count do |obstacle|
        horizontals = horizontal_neighbors(obstacle) # points around obstacle
        verticals = vertical_neighbors(obstacle)

        (horizontals.count == 2 && check.(diff(*horizontals))) ||
          (verticals.count == 2 && check.(diff(*verticals)))
      end
    end

    private

    def dijkstra
      @distances = { @start => 0 }
      queue = [@start]

      while current = queue.shift # BFS, to traverse layer by layer, so the current distance is minimal
        neighbors(current).each do |neighbor|
          next if @distances[neighbor]
          @distances[neighbor] = @distances[current] + 1
          queue << neighbor
        end
      end
    end

    def neighbors(point) = horizontal_neighbors(point) + vertical_neighbors(point)

    def horizontal_neighbors(point) = neighbors_by_shifts([[0, 1], [0, -1]], point)

    def vertical_neighbors(point) = neighbors_by_shifts([[-1, 0], [1, 0]], point)

    def neighbors_by_shifts(shifts, point)
      shifts.map { |(x, y)| [point[0] + x, point[1] + y] }.
        filter { |pos| pos[0] > 0 && pos[1] > 0 && pos[0] < @board.size - 1 && pos[1] < @board[0].size - 1 && walkable?(pos) }
    end

    def walkable?(point) = @board[point[0]][point[1]] != '#'

    def diff(point1, point2) = (@distances[point1] - @distances[point2]).abs - 2 # -2 to overcome obstacle

    def obstacles
      hashtags = []
      @board.each_with_index do |line, row|
        line.each_with_index do |e, col|
          hashtags << [row, col] if e == '#' && row > 0 && col > 0 && row < @board.size - 1 && col < @board[0].size - 1
        end
      end
      hashtags
    end

    def parse(input)
      @board = input.split("\n").map { _1.chars }

      @board.each_with_index do |line, row|
        line.each_with_index do |e, col|
          @start = [row, col] if e == 'S'
          @end = [row, col] if e == 'E'
        end
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

solver = Day20::Part1.new(test_data)
fail 'error' unless solver.call { _1 == 2 } == 14
fail 'error' unless solver.call { _1 == 4 } == 14
fail 'error' unless solver.call { _1 == 6 } == 2
fail 'error' unless solver.call { _1 == 8 } == 4
fail 'error' unless solver.call { _1 == 10 } == 2
fail 'error' unless solver.call { _1 == 12 } == 3
fail 'error' unless solver.call { _1 == 20 } == 1
fail 'error' unless solver.call { _1 == 36 } == 1
fail 'error' unless solver.call { _1 == 38 } == 1
fail 'error' unless solver.call { _1 == 40 } == 1
fail 'error' unless solver.call { _1 == 64 } == 1
