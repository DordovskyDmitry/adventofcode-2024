require_relative '1'

module Day2
  class Part2 < Part1

    private

    def safe?(report)
      monotone_subset?(report) { _2 - _1 } || monotone_subset?(report) { _1 - _2 }
    end

    def monotone_subset?(report, &diff)
      report.each_index.any? do |i|
        monotone?(report[0...i] + report[i + 1...], &diff)
      end
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

fail 'error' unless Day2::Part2.new(test_data).call == 4
