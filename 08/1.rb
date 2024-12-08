module Day8
  class Part1
    def initialize(input)
      @board = parse(input)
      @data = {}
      @board.each_with_index do |line, row|
        line.each_with_index do |e, col|
          if e != '.'
            @data[e] ||= []
            @data[e] << [row, col]
          end
        end
      end
    end

    def call
      antinodes = Set.new

      @data.each do |_, vs|
        all_pairs(vs).each do |p1, p2|
          dx = p1[0] - p2[0]
          dy = p1[1] - p2[1]

          x1 = p1[0] + dx
          y1 = p1[1] + dy
          if board? x1, y1
            antinodes << [x1, y1]
          end

          x2 = p2[0] - dx
          y2 = p2[1] - dy
          if board? x2, y2
            antinodes << [x2, y2]
          end
        end
      end
      antinodes.count
    end

    private

    def all_pairs(points)
      pairs = []
      (0..points.size - 2).each do |i|
        (i + 1..points.size - 1).each do |j|
          pairs << [points[i], points[j]]
        end
      end
      pairs
    end

    def board?(x, y)
      x >= 0 && y >= 0 && x < @board.size && y < @board[0].size
    end

    def parse(input)
      input.split("\n").map { _1.chars }
    end
  end
end

test_data = <<~DATA
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
DATA

fail 'error' unless Day8::Part1.new(test_data).call == 14
