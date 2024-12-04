module Day4
  class Part2
    attr_reader :data, :rows, :cols

    def initialize(input)
      @data = parse_input(input)
      @rows = @data.length
      @cols = @data[0].length
    end

    def call
      quantity = 0

      data.each_with_index do |row, i|
        row.each_with_index do |_, j|
          if x_mas_starts?(i, j)
            quantity += 1
          end
        end
      end

      quantity
    end

    private

    def x_mas_starts?(i, j)
      if i > rows - 3 || j > cols - 3
        return false
      end

      up_M(i, j) || right_M(i, j) || down_M(i, j) || left_M(i, j)
    end

    def up_M(i, j)
      data[i][j] == 'M' &&
        data[i][j + 2] == 'M' &&
        data[i + 1][j + 1] == 'A' &&
        data[i + 2][j] == 'S' &&
        data[i + 2][j + 2] == 'S'
    end

    def right_M(i, j)
      data[i][j] == 'S' &&
        data[i][j + 2] == 'M' &&
        data[i + 1][j + 1] == 'A' &&
        data[i + 2][j] == 'S' &&
        data[i + 2][j + 2] == 'M'
    end

    def down_M(i, j)
      data[i][j] == 'S' &&
        data[i][j + 2] == 'S' &&
        data[i + 1][j + 1] == 'A' &&
        data[i + 2][j] == 'M' &&
        data[i + 2][j + 2] == 'M'
    end

    def left_M(i, j)
      data[i][j] == 'M' &&
        data[i][j + 2] == 'S' &&
        data[i + 1][j + 1] == 'A' &&
        data[i + 2][j] == 'M' &&
        data[i + 2][j + 2] == 'S'
    end

    def parse_input(input)
      input.split("\n").map { _1.chars }
    end
  end
end

test_data = <<~DATA
  .M.S......
  ..A..MSMS.
  .M.S.MAA..
  ..A.ASMSM.
  .M.S.M....
  ..........
  S.S.S.S.S.
  .A.A.A.A..
  M.M.M.M.M.
  ..........
DATA

fail 'error' unless Day4::Part2.new(test_data).call == 9
