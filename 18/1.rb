module Day18
  class Part1
    def initialize(input, size, fallen)
      @corrupted = input.split("\n").map { _1.split(',').map(&:to_i).reverse }.take(fallen).to_set
      @size = size
      @board = Array.new(size) { Array.new(size) }
      @start = [0, 0]
      @end = [size - 1, size - 1]
    end

    def call
      distances = { @start => 0 }
      queue = [@start]

      while current = queue.shift # BFS, to traverse layer by layer, so the current distance is minimal
        neighbors(current).each do |neighbor|
          next if distances[neighbor]
          distances[neighbor] = distances[current] + 1
          queue << neighbor
        end
      end

      distances[@end]
    end

    private

    def neighbors(point)
      [[-1, 0], [0, 1], [1, 0], [0, -1]].
        map { |(x, y)| [point[0] + x, point[1] + y] }.
        filter { |(x, y)| x >= 0 && y >= 0 && x < @size && y < @size && !@corrupted.include?(point) }
    end
  end
end

test_data = <<~DATA
  5,4
  4,2
  4,5
  3,0
  2,1
  6,3
  2,4
  1,5
  0,6
  3,3
  2,6
  5,1
  1,2
  5,5
  2,5
  6,5
  1,4
  0,4
  6,4
  1,1
  6,1
  1,0
  0,5
  1,6
  2,0
DATA
fail 'error' unless Day18::Part1.new(test_data, 7, 12).call == 22
