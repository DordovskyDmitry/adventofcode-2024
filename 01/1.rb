module Day1
  class Part1
    def initialize(input)
      @data = parse_data(input)
    end

    def call
      firsts = @data.map(&:first).sort
      seconds = @data.map(&:last).sort

      firsts.zip(seconds).reduce(0) do |agg, (f1, s1)|
        agg + (f1 - s1).abs
      end
    end

    private

    def parse_data(input)
      input.split("\n").map { _1.split(' ').map(&:to_i) }
    end
  end
end

test_data = <<~DATA
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
DATA

fail 'error' unless Day1::Part1.new(test_data).call == 11
