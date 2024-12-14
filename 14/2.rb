module Day14
  class Part2
    def initialize(input, height, width)
      @data = parse(input)
      @height = height
      @width = width
    end

    def call
      (1000...10000).each do |seconds|
        positions = @data.reduce(Set.new([])) do |agg, (point, vel)|
          agg << [(point[0] + vel[0] * seconds) % @height,
                  (point[1] + vel[1] * seconds) % @width]
        end
        print_board(positions, seconds)
      end
    end

    private

    def print_board(positions, seconds)
      p '-----------------'
      p seconds
      @height.times do |row|
        @width.times do |col|
          print(positions.include?([row, col]) ? '#' : ' ')
        end
        print("\n")
      end
    end

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
