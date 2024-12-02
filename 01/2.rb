module Day1
  class Part2
    def initialize(input)
      @data = parse_data(input)
    end

    def call
      firsts = @data.map(&:first)
      seconds = @data.map(&:last).group_by(&:itself).transform_values(&:count)

      firsts.reduce(0) do |agg, f1|
        agg + (seconds[f1] || 0) * f1
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

fail 'error' unless Day1::Part2.new(test_data).call == 31
