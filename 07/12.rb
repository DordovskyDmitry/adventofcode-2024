module Day7
  class Part12
    def initialize(input, ops)
      @data = parse(input)
      @ops = ops
    end

    def call
      @data.sum do |(res, vs)|
        solvable?(res, vs) ? res : 0
      end
    end

    private

    def solvable?(k, vs)
      queue = [vs]

      until queue.empty?
        e = queue.pop

        return true if e.size == 1 && e.first == k
        next if e.size == 1
        next if e.first > k

        @ops.each do |op|
          res = op.(e[0], e[1])
          queue.push([res, *e[2...]])
        end
      end

      false
    end

    def parse(input)
      input.split("\n").each_with_object([]) do |line, agg|
        res, values_line = line.split(': ')
        agg << [res.to_i, values_line.split.map(&:to_i)]
      end
    end
  end
end

test_data = <<~DATA
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
DATA

ops1 = [:+.to_proc, :*.to_proc]
fail 'error' unless Day7::Part12.new(test_data, ops1).call == 3749

ops2 = [:+.to_proc, :*.to_proc, -> (x, y) { "#{x}#{y}".to_i }]
fail 'error' unless Day7::Part12.new(test_data, ops2).call == 11387
