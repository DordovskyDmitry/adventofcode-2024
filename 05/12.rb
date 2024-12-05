require_relative '../utils/tsort_hash'

module Day5
  class Part12
    def initialize(input)
      parse(input)
    end

    def call
      part1, part2 = @updates.partition(&method(:valid?))

      [part1.sum { |update| update[update.length / 2].to_i },
       part2.sum { |update| sort(update)[update.length / 2].to_i }]
    end

    private

    def valid?(update)
      update.each_with_index.all? do |e, i|
        orders = @orders[e] || []
        (update[i + 1...] & orders).size == update[i + 1...].size
      end
    end

    def sort(update)
      sorted = TSortHash[@orders.slice(*update)].tsort
      update.sort_by { sorted.index(_1) }
    end

    def parse(input)
      orders, updates = input.split("\n\n").map { _1.split("\n") }
      @orders = orders.map { _1.split('|') }.
        group_by(&:first).
        transform_values { _1.map(&:last) }
      @updates = updates.map { _1.split(',') }
    end
  end
end

test_data = <<~DATA
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
DATA

fail 'error' unless Day5::Part12.new(test_data).call == [143, 123]
