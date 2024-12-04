module Day4
  class Part1
    attr_reader :data, :rows, :cols

    def initialize(input)
      @data = parse_input(input)
      @rows = @data.length
      @cols = @data[0].length
    end

    def call
      quantity = 0

      data.each_with_index do |row, i|
        row.each_with_index do |l, j|
          next unless l == 'X'

          quantity += 1 if up_left(i, j)
          quantity += 1 if up(i, j)
          quantity += 1 if up_right(i, j)
          quantity += 1 if right(i, j)
          quantity += 1 if down_right(i, j)
          quantity += 1 if down(i, j)
          quantity += 1 if down_left(i, j)
          quantity += 1 if left(i, j)
        end
      end

      quantity
    end

    private

    def up_left(i, j)
      if i >= 3 && j >= 3
        data[i - 1][j - 1] == 'M' &&
          data[i - 2][j - 2] == 'A' &&
          data[i - 3][j - 3] == 'S'
      end
    end

    def up(i, j)
      if i >= 3
        data[i - 1][j] == 'M' &&
          data[i - 2][j] == 'A' &&
          data[i - 3][j] == 'S'
      end
    end

    def up_right(i, j)
      if i >= 3 && j < cols - 3
        data[i - 1][j + 1] == 'M' &&
          data[i - 2][j + 2] == 'A' &&
          data[i - 3][j + 3] == 'S'
      end
    end

    def right(i, j)
      if j < cols - 3
        data[i][j + 1] == 'M' &&
          data[i][j + 2] == 'A' &&
          data[i][j + 3] == 'S'
      end
    end

    def down_right(i, j)
      if i < rows - 3 && j < cols - 3
        data[i + 1][j + 1] == 'M' &&
          data[i + 2][j + 2] == 'A' &&
          data[i + 3][j + 3] == 'S'
      end
    end

    def down(i, j)
      if i < rows - 3
        data[i + 1][j] == 'M' &&
          data[i + 2][j] == 'A' &&
          data[i + 3][j] == 'S'
      end
    end

    def down_left(i, j)
      if i < rows - 3 && j >= 3
        data[i + 1][j - 1] == 'M' &&
          data[i + 2][j - 2] == 'A' &&
          data[i + 3][j - 3] == 'S'
      end
    end

    def left(i, j)
      if j >= 3
        data[i][j - 1] == 'M' &&
          data[i][j - 2] == 'A' &&
          data[i][j - 3] == 'S'
      end
    end

    def parse_input(input)
      input.split("\n").map { _1.chars }
    end
  end
end

test_data = <<~DATA
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
DATA

fail 'error' unless Day4::Part1.new(test_data).call == 18
