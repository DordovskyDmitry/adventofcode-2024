require_relative '1'

module Day8
  class Part2 < Part1

    def call
      antinodes = Set.new

      @data.each do |_, vs|
        all_pairs(vs).each do |p1, p2|
          dx = p1[0] - p2[0]
          dy = p1[1] - p2[1]

          x1, y1 = p1
          while board? x1, y1
            antinodes << [x1, y1]
            x1 += dx
            y1 += dy
          end

          x2, y2 = p2
          while board? x2, y2
            antinodes << [x2, y2]
            x2 -= dx
            y2 -= dy
          end
        end
      end

      antinodes.count
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
fail 'error' unless Day8::Part2.new(test_data).call == 34

test_data = <<~DATA
  T.........
  ...T......
  .T........
  ..........
  ..........
  ..........
  ..........
  ..........
  ..........
  ..........
DATA
fail 'error' unless Day8::Part2.new(test_data).call == 9