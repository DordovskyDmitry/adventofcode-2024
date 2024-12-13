require 'matrix'

module Day13
  class Part2Matrix
    ADD = 10000000000000
    A_WEIGHT = 3
    B_WEIGHT = 1

    def initialize(input)
      @tasks = parse(input)
    end

    def call
      @tasks.sum do |task|
        det = task[0].det

        res = 0
        if det != 0
          a, b = (task[0].inverse * task[1]).to_a
          if a > 0 && b > 0 && a.to_i == a && b.to_i == b
            res = a.to_i * A_WEIGHT + b.to_i * B_WEIGHT
          end
        end
        res
      end
    end

    private

    def parse(input)
      input.split("\n\n").map do |task|
        a_line, b_line, prize_line = task.split("\n")
        a1, a2 = a_line.match(/Button A: X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
        b1, b2 = b_line.match(/Button B: X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
        x, y = prize_line.match(/Prize: X=(\d+), Y=(\d+)/).captures.map(&:to_i)
        [Matrix[[a1, b1], [a2, b2]], Vector[x + ADD, y + ADD]]
      end
    end
  end
end
