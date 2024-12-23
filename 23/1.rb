module Day23
  class Part1
    def initialize(test_data, size = 3)
      @connections = test_data.split("\n").each_with_object({}) do |raw, acc|
        c1, c2 = raw.split('-')
        acc[c1] ||= Set.new
        acc[c2] ||= Set.new
        acc[c1].add(c2)
        acc[c2].add(c1)
      end
      @size = size
    end

    def call
      triples = @connections.each_with_object(Set.new) do |(k, values), acc|
        values.each do |v|
          (@connections[v] & @connections[k]).each do |common|
            acc.add Set.new([k, v, common])
          end
        end
      end

      triples.count do |set|
        set.any? { |c| c.start_with?('t') }
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

fail 'error' unless Day23::Part1.new(test_data).call == 7
