module Day3
  class Part1
    def initialize(input)
      @input = input
    end

    def call
      @input.scan(/mul\((\d{1,3})\,(\d{1,3})\)/).sum do |d1, d2|
        d1.to_i * d2.to_i
      end
    end
  end
end

test_data = <<~DATA
  xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
DATA

fail 'error' unless Day3::Part1.new(test_data).call == 161
