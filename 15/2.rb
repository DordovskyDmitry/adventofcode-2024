require_relative '1'

module Day15
  class Part2 < Part1
    private

    def simulate_moves
      @moves.each do |move|
        case move
        when '<', '>'
          dy = move == '>' ? 1 : -1
          to_move = [@robot_pos]
          shift = 0

          while (value(to_move.last) != '.') && (value(to_move.last) != '#')
            shift += 1
            to_move << [to_move.last[0], to_move.last[1] + dy]
          end
          next if value(to_move.last) == '#'

          to_move.reverse.each_cons(2) do |p1, p2|
            @board[p1[0]][p1[1]], @board[p2[0]][p2[1]] = @board[p2[0]][p2[1]], @board[p1[0]][p1[1]]
          end

          @robot_pos = [@robot_pos[0], @robot_pos[1] + dy]
        when '^', 'v'
          dx = move == 'v' ? 1 : -1
          next_pos = [@robot_pos[0] + dx, @robot_pos[1]]
          if value(next_pos) == '#'
            next
          elsif value(next_pos) == '.'
            move_current_to(next_pos)
          else
            to_move = blocks_to_move(dx, next_pos)

            # Move all 2-block parts
            to_move.reverse[0...-1].each do |point|
              @board[point[0] + dx][point[1]] = @board[point[0]][point[1]]
              @board[point[0] + dx][point[1] + 1] = @board[point[0]][point[1] + 1]
              @board[point[0]][point[1]] = '.'
              @board[point[0]][point[1] + 1] = '.'
            end

            # move robot if 2-blocks were moved
            if to_move.any?
              move_current_to(next_pos)
            end
          end
        end
      end
    end

    def blocks_to_move(dx, point)
      to_move = [@robot_pos]

      if value(point) == '['
        current_layer = [point]
        to_move << point
      elsif value(point) == ']'
        current_layer = [[point[0], point[1] - 1]]
        to_move << current_layer.first
      else
        fail 'Unknown character'
      end

      # find all elements that should be moved (layer by layer)
      while current_layer.any?
        next_layer = []
        current_layer.each do |point|
          if value([point[0] + dx, point[1]]) == '#' || value([point[0] + dx, point[1] + 1]) == '#'
            to_move = []
            next_layer = []
            break
          end

          if value([point[0] + dx, point[1] - 1]) == '['
            next_layer << [point[0] + dx, point[1] - 1]
          end

          if value([point[0] + dx, point[1]]) == '['
            next_layer << [point[0] + dx, point[1]]
          end

          if value([point[0] + dx, point[1] + 1]) == '['
            next_layer << [point[0] + dx, point[1] + 1]
          end
        end

        current_layer = next_layer.uniq
        to_move += current_layer
      end

      to_move
    end

    def move_current_to(point)
      @board[point[0]][point[1]] = '@'
      @board[@robot_pos[0]][@robot_pos[1]] = '.'
      @robot_pos = point
    end

    def box = '['

    def parse(input)
      input.gsub('#', '##').gsub('O', '[]').gsub('.', '..').gsub('@', '@.').split("\n\n")
    end
  end
end

test_data = <<~DATA
  #######
  #.....#
  #.OOO.#
  #..OO@#
  #..O..#
  #.....#
  #######

  <vv<<^
DATA

fail 'error 1' unless Day15::Part2.new(test_data).call == 1036

test_data = <<~DATA
  #######
  #...#.#
  #.....#
  #..OO@#
  #..O..#
  #.....#
  #######

  <vv<<^^<<^^
DATA

fail 'error 1' unless Day15::Part2.new(test_data).call == 618

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

fail 'error 2' unless Day15::Part2.new(test_data).call == 9021
