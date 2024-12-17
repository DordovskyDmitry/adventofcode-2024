require_relative '1'

module Day17
  class Part2
    def initialize(input)
      _, program = input.split("\n\n")
      @program = program.scan(/(\d+)/).flatten.map(&:to_i)
    end

    def call
      f = interval(2, 1, 64) * 64

      (4..@program.length).step(2).map do |pow|
        from = f
        to = from + 8 ** (pow - 1)
        f = interval(pow, from, to) * 64
      end.last / 64
    end

    private

    def interval(pow, from, to)
      (from...to).each do |a|
        registers = { A: a, B: 0, C: 0 }
        if try(registers).last(pow) == @program.last(pow)
          return a
        end
      end
    end

    def try(registers)
      Day17::Part1.new(@program, registers).call
    end
  end
end

test_data = <<~DATA
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,3,5,4,3,0
DATA
fail 'error' unless Day17::Part2.new(test_data).call == 117440
