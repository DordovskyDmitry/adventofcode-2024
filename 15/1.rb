module Day15
  class Part1
    MOVES = {
      '^' => [-1, 0],
      '>' => [0, 1],
      'v' => [1, 0],
      '<' => [0, -1]
    }

    def initialize(input)
      board_data, move_data = parse(input)
      @board = board_data.split("\n").map { _1.chars }
      @moves = move_data.lines.map(&:strip).join.chars
      @robot_pos = find_robot
    end

    def call
      simulate_moves
      calc_result
    end

    private

    def simulate_moves
      @moves.each do |move|
        dx, dy = MOVES[move]
        shift_to = @robot_pos
        shift = 0
        while (value(shift_to) != '.') && (value(shift_to) != '#')
          shift += 1
          shift_to = [shift_to[0] + dx, shift_to[1] + dy]
        end

        next if value(shift_to) == '#'

        @board[@robot_pos[0]][@robot_pos[1]] = '.'
        @robot_pos = [@robot_pos[0] + dx, @robot_pos[1] + dy]
        @board[@robot_pos[0]][@robot_pos[1]] = '@'
        @board[shift_to[0]][shift_to[1]] = 'O' if shift > 1
      end
    end

    def calc_result
      sum = 0

      @board.each_with_index do |line, row|
        line.each_with_index do |e, col|
          if e == box
            sum += (100 * row + col)
          end
        end
      end

      sum
    end

    def box = 'O'

    def value(point)
      @board[point[0]][point[1]]
    end

    def find_robot
      (0..@board.size - 1).to_a.product((0..@board[0].size - 1).to_a).detect { |row, col| @board[row][col] == '@' }
    end

    def parse(input)
      input.split("\n\n")
    end
  end
end

test_data = <<~DATA
  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  <^^>>>vv<v>>v<<
DATA

fail 'error 1' unless Day15::Part1.new(test_data).call == 2028

test_data = <<~DATA
  ##########
  #..O..O.O#
  #......O.#
  #.OO..O.O#
  #..O@..O.#
  #O#..O...#
  #O..O..O.#
  #.OO.O.OO#
  #....O...#
  ##########

  <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
  vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
  ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
  <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
  ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
  ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
  >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
  <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
  ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
  v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
DATA

fail 'error 2' unless Day15::Part1.new(test_data).call == 10092
