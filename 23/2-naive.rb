module Day23
  class Part2Naive
    def initialize(test_data, size = 3)
      @connections = test_data.split("\n").each_with_object({}) do |raw, acc|
        c1, c2 = raw.split('-')
        acc[c1] ||= []
        acc[c2] ||= []
        acc[c1] << c2
        acc[c2] << c1
      end
      @size = size
    end

    def call
      max_length = 0
      winner = []

      @connections.each do |(k, values)|
        values.each do |v|
          possible = @connections[v] & @connections[k]
          longest_net = combinations(possible).filter { |array| connected?(array) }.max_by(&:length)

          if longest_net && max_length < longest_net.length
            winner = [k, v, *longest_net]
            max_length = longest_net.length
          end
        end
      end

      winner.sort.join(',')
    end

    def combinations(array)
      (2..array.length).map { |i| array.combination(i).to_a }.flatten(1)
    end

    def connected?(array)
      (0..array.size - 2).each do |i|
        (i + 1..array.size - 1).each do |j|
          unless @connections[array[i]].include?(array[j])
            return false
          end
        end
      end

      true
    end
  end
end

test_data = <<~DATA
  kh-tc
  qp-kh
  de-cg
  ka-co
  yn-aq
  qp-ub
  cg-tb
  vc-aq
  tb-ka
  wh-tc
  yn-cg
  kh-ub
  ta-co
  de-co
  tc-td
  tb-wq
  wh-td
  ta-ka
  td-qp
  aq-cg
  wq-ub
  ub-vc
  de-ta
  wq-aq
  wq-vc
  wh-yn
  ka-de
  kh-ta
  co-tc
  wh-qp
  tb-vc
  td-yn
DATA

fail 'error' unless Day23::Part2Naive.new(test_data).call == 'co,de,ka,ta'
