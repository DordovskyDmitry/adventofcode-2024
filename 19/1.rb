module Day19
  class Part1
    def initialize(input)
      parse(input)
    end

    def call
      @towels.count { |towel| towel.match(/\A(#{@patterns.join('|')})+\z/) }
    end

    private

    def parse(input)
      patterns, towels = input.split("\n\n")
      @patterns = patterns.split(', ')
      @towels = towels.split("\n")
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
fail 'error' unless Day19::Part1.new(test_data).call == 6
