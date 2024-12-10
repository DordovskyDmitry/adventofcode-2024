module Day10
  class Part12
    START = 0
    FINISH = 9

    def initialize(input)
      @board = input.split("\n").map { _1.chars.map(&:to_i) }
      @origins = []
      @board.each_with_index do |line, row|
        line.each_with_index do |n, col|
          if n == START
            @origins << [row, col]
          end
        end
      end
    end

    def call
      from_to = Set.new
      count = 0
      queue = @origins.map { |tuple| [tuple] }

      while e = queue.pop
        x, y = e.last

        if @board[x][y] == FINISH
          from_to.add([e.first, e.last])
          count += 1
          next
        end

        [[x + 1, y], [x - 1, y], [x, y - 1], [x, y + 1]].each do |i, j|
          if (0...@board.size).include?(i) &&
            (0...@board[0].size).include?(j) &&
            (@board[x][y] + 1 == @board[i][j])

            queue.push(e + [[i, j]])
          end
        end
      end

      [from_to.count, count]
    end
  end
end

test_data = <<~DATA
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
DATA

fail 'error' unless Day10::Part12.new(test_data).call == [36, 81]
