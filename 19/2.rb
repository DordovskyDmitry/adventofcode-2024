module Day19
  class Part2
    def initialize(input)
      parse(input)
    end

    def call
      @counts = {}
      @towels.sum { |towel| count(towel) }
    end

    private

    def count(towel)
      return 1 if towel.empty?

      length = [@max_length, towel.size].min

      (0..length - 1).sum do |i|
        if @patterns.include? towel[0..i]
          @counts[towel[i + 1...]] ||= count(towel[i + 1...])
        else
          0
        end
      end
    end

    def parse(input)
      patterns, towels = input.split("\n\n")
      @patterns = Set.new(patterns.split(', '))
      @towels = towels.split("\n")
      @max_length = @patterns.map(&:length).max
    end
  end
end

test_data = <<~DATA
  r, wr, b, g, bwu, rb, gb, br

  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
DATA
fail 'error' unless Day19::Part2.new(test_data).call == 16
