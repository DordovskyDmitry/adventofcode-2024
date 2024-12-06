class LoopFinder
  OBSTACLE = '#'
  START_DIRECTION = :up

  TURNS = {
    up: :right,
    right: :down,
    down: :left,
    left: :up
  }

  def initialize(board, row, col)
    @board = board
    @height = board.size
    @width = board.first.size
    @init_row = row
    @init_col = col
    @init_direction = START_DIRECTION
  end

  def path_to_leave_zone
    @row = @init_row
    @col = @init_col
    @direction = @init_direction

    visited = Set.new

    until boundary_reached?
      visited.add([@row, @col])
      step_forward || make_turn
    end

    visited.add([@row, @col])
  end

  def with_loop?
    @row = @init_row
    @col = @init_col
    @direction = @init_direction

    visited = Set.new

    loop do
      if visited.include?([@row, @col, @direction])
        return true
      end
      if boundary_reached?
        return false
      end
      visited.add([@row, @col, @direction])
      step_forward || make_turn
    end
  end

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
end

module Day6
  class Part2
    OBSTACLE = LoopFinder::OBSTACLE
    START_SYMBOL = '^'

    def initialize(input)
      parse(input)
    end

    def call
      LoopFinder.new(@board, @row, @col).
        path_to_leave_zone.
        count do |(row, col)|
        new_board = @board.map(&:dup)
        new_board[row][col] = OBSTACLE
        LoopFinder.new(new_board, @row, @col).with_loop?
      end
    end

    private

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

fail 'error' unless Day6::Part2.new(test_data).call == 6
