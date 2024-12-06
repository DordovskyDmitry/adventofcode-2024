module Day6
  class Part1
    OBSTACLE = '#'
    START_SYMBOL = '^'
    START_DIRECTION = :up

    TURNS = {
      up: :right,
      right: :down,
      down: :left,
      left: :up
    }

    def initialize(input)
      parse(input)

      @direction = START_DIRECTION
    end

    def call
      visited = Set.new

      until boundary_reached?
        visited.add([@row, @col])
        step_forward || make_turn
      end

      visited.count + 1
    end

    private

    def step_forward
      case @direction
      when :up
        if @row > 0 && @board[@row - 1][@col] != OBSTACLE
          @row -= 1
        end
      when :right
        if @col < @width - 1 && @board[@row][@col + 1] != OBSTACLE
          @col += 1
        end
      when :down
        if @row < @height - 1 && @board[@row + 1][@col] != OBSTACLE
          @row += 1
        end
      when :left
        if @col > 0 && @board[@row][@col - 1] != OBSTACLE
          @col -= 1
        end
      end
    end

    def make_turn
      @direction = TURNS[@direction]
      step_forward
    end

    def boundary_reached?
      @row == 0 || @row == @height - 1 || @col == 0 || @col == @width - 1
    end

    def parse(input)
      @board = input.split("\n").map { _1.chars }
      @height = @board.size
      @width = @board[0].size

      (0..@height - 1).each do |row|
        break if @row

        (0..@width - 1).each do |col|
          if @board[row][col] == START_SYMBOL
            @row = row
            @col = col

            break
          end
        end
      end
    end
  end
end

test_data = <<~DATA
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
DATA

fail 'error' unless Day6::Part1.new(test_data).call == 41
