module Day11
  class Part12
    def initialize(input, ticks)
      @stones = input.split.map(&:to_i)
      @ticks = ticks
    end

    def call
      @counts = {}
      @stones.sum do |stone|
        count(stone, @ticks)
      end
    end

    private

    def count(stone, deep)
      return @counts[[stone, deep]] if @counts.key?([stone, deep])
      return 1 if deep == 0

      @counts[[stone, deep]] = transform(stone).sum { |sub_st| count(sub_st, deep - 1) }
    end

    def transform(stone)
      if stone == 0
        [1]
      elsif stone.digits.count.even?
        new_length = stone.digits.count / 2
        stone.divmod(10.pow(new_length))
      else
        [stone * 2024]
      end
    end
  end
end

fail 'error 1' unless Day11::Part12.new('0 1 10 99 999', 1).call == 7
fail 'error 2' unless Day11::Part12.new('125 17', 6).call == 22
fail 'error 3' unless Day11::Part12.new('125 17', 25).call == 55312
