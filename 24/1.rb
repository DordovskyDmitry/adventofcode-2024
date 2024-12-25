require_relative '../utils/tsort_hash'

module Day24
  class Part1
    OPS = {
      'AND' => :&,
      'OR' => :|,
      'XOR' => :^,
    }

    def initialize(input)
      init, dependencies = input.split("\n\n")
      @values = init.lines.each_with_object({}) do |line, acc|
        wire, val = line.split(': ')
        acc[wire] = val.to_i
      end

      @dependencies = {}
      @rules = {}
      dependencies.lines.each do |line|
        w1, op, w2, _, w3 = line.split(' ')
        @dependencies[w3] = [w1, w2]
        @rules[w3] = OPS[op]
      end
    end

    def call
      TSortHash[@dependencies].tsort.each do |w|
        next if @values[w]

        @values[w] = @dependencies[w].map { @values[_1] }.reduce(@rules[w])
      end

      @values.filter{|k, _| k.start_with?('z') }.sort.reverse.map { _1[1] }.join.to_i(2)
    end
  end
end

test_data = <<~DATA
  x00: 1
  x01: 1
  x02: 1
  y00: 0
  y01: 1
  y02: 0

  x00 AND y00 -> z00
  x01 XOR y01 -> z01
  x02 OR y02 -> z02
DATA

fail 'error 0' unless Day24::Part1.new(test_data).call == 4

test_data = <<~DATA
  x00: 1
  x01: 0
  x02: 1
  x03: 1
  x04: 0
  y00: 1
  y01: 1
  y02: 1
  y03: 1
  y04: 1

  ntg XOR fgs -> mjb
  y02 OR x01 -> tnw
  kwq OR kpj -> z05
  x00 OR x03 -> fst
  tgd XOR rvg -> z01
  vdt OR tnw -> bfw
  bfw AND frj -> z10
  ffh OR nrd -> bqk
  y00 AND y03 -> djm
  y03 OR y00 -> psh
  bqk OR frj -> z08
  tnw OR fst -> frj
  gnj AND tgd -> z11
  bfw XOR mjb -> z00
  x03 OR x00 -> vdt
  gnj AND wpb -> z02
  x04 AND y00 -> kjc
  djm OR pbm -> qhw
  nrd AND vdt -> hwm
  kjc AND fst -> rvg
  y04 OR y02 -> fgs
  y01 AND x02 -> pbm
  ntg OR kjc -> kwq
  psh XOR fgs -> tgd
  qhw XOR tgd -> z09
  pbm OR djm -> kpj
  x03 XOR y03 -> ffh
  x00 XOR y04 -> ntg
  bfw OR bqk -> z06
  nrd XOR fgs -> wpb
  frj XOR qhw -> z04
  bqk OR frj -> z07
  y03 OR x01 -> nrd
  hwm AND bqk -> z03
  tgd XOR rvg -> z12
  tnw OR pbm -> gnj
DATA

fail 'error 1' unless Day24::Part1.new(test_data).call == 2024
