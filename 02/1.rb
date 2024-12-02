module Day2
  class Part1
    def initialize(input)
      @data = parse_data(input)
    end

    def call
      @data.count(&method(:safe?))
    end

    private

    def safe?(report)
      monotone?(report) { _2 - _1 } || monotone?(report) { _1 - _2 }
    end

    def monotone?(report, &diff)
      report.each_cons(2).all? do |l1, l2|
        d = diff.(l1, l2)
        d > 0 && d < 4
      end
    end

    def parse_data(input)
      input.split("\n").map { _1.split(' ').map(&:to_i) }
    end
  end
end

test_data = <<~DATA
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
DATA

fail 'error' unless Day2::Part1.new(test_data).call == 2
