require_relative '1'

module Day22
  class Part2 < Part1

    def call
      @numbers.reduce({}) do |agg, secret|
        @count.times.reduce([secret % 10]) { |acc, _| secret = evolve(secret); acc << secret % 10 }.# calc secrets last digits
        each_cons(2).map { |(x, y)| [y, y - x] }.# prices and the associated changes
        each_cons(4).reduce({}) do |acc, four|
          # prices and the last four changes
          key = four.map(&:last)
          acc[key] ? acc : acc.merge(key => four.last.first)
        end.merge(agg) { |_, trend_value, acc_val| acc_val + trend_value } # sum prices for the last four changes for all inputs
      end.values.max
    end
  end
end

test_data = <<~DATA
  123
DATA
fail 'error' unless Day22::Part2.new(test_data, 10).call == 6

test_data = <<~DATA
  1
  2
  3
  2024
DATA
fail 'error' unless Day22::Part2.new(test_data, 2000).call == 23
