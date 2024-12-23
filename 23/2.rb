# watched in HyperNeutrino youtube channel
# more efficient than I used to resolve my input

module Day23
  class Part2
    def initialize(test_data, size = 3)
      @connections = test_data.split("\n").each_with_object({}) do |raw, acc|
        c1, c2 = raw.split('-')
        acc[c1] ||= Set.new
        acc[c2] ||= Set.new
        acc[c1] << c2
        acc[c2] << c1
      end
      @size = size
    end

    def call
      @sets = Set.new

      @connections.map { |(k, _)| search(k, Set.new([k])) }

      @sets.max_by(&:length).to_a.sort.join(',')
    end

    def search(k, set)
      return if @sets.include? set

      @sets << set

      @connections[k].each do |v|
        next if set.include?(v)
        if set.all? { |e| @connections[e].include? v }
          search(v, set + [v])
        end
      end
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

fail 'error' unless Day23::Part2.new(test_data).call == 'co,de,ka,ta'
