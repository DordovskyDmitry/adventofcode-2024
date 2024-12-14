module Day14
  class Part1
    SECONDS = 100

    def initialize(input, height, width)
      @data = parse(input)
      @height = height
      @width = width
    end

    def call
      positions = @data.reduce([]) do |agg, (point, vel)|
        agg << [(point[0] + vel[0] * SECONDS) % @height,
                (point[1] + vel[1] * SECONDS) % @width]
      end

      top_left = positions.count { |pos| (pos[0] < @height / 2) && (pos[1] < @width / 2) }
      top_right = positions.count { |pos| (pos[0] < @height / 2) && (pos[1] > @width / 2) }
      down_left = positions.count { |pos| (pos[0] > @height / 2) && (pos[1] < @width / 2) }
      down_right = positions.count { |pos| (pos[0] > @height / 2) && (pos[1] > @width / 2) }

      [top_left, top_right, down_left, down_right].reduce(:*)
    end

    private

    def parse(input)
      input.lines.map do |line|
        pos, vel = line.split(' ')
        w, h = pos[2..].split(',').map(&:to_i)
        vw, vh = vel[2...].split(',').map(&:to_i)
        [[h, w], [vh, vw]]
      end
    end
  end
end

test_data = <<~DATA
  p=0,4 v=3,-3
  p=6,3 v=-1,-3
  p=10,3 v=-1,2
  p=2,0 v=2,-1
  p=0,0 v=1,3
  p=3,0 v=-2,-2
  p=7,6 v=-1,-3
  p=3,0 v=-1,-2
  p=9,3 v=2,3
  p=7,3 v=-1,2
  p=2,4 v=2,-3
  p=9,5 v=-3,-3
DATA

fail 'error' unless Day14::Part1.new(test_data, 7, 11).call == 12
