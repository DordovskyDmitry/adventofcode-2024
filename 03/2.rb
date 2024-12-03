module Day3
  class Part2
    def initialize(input)
      @input = input
    end

    def call
      chunks = @input.split('do()')
      chunks.sum do |chunk|
        do_chunk = chunk.split("don't()").first
        calc_pure_chunk(do_chunk)
      end
    end

    private

    def calc_pure_chunk(chunk)
      chunk.scan(/mul\((\d{1,3})\,(\d{1,3})\)/).sum do |d1, d2|
        d1.to_i * d2.to_i
      end
    end
  end
end

test_data = <<~DATA
  xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
DATA

fail 'error' unless Day3::Part2.new(test_data).call == 48
