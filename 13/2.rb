module Day13
  class Part2
    ADD = 10000000000000
    A_WEIGHT = 3
    B_WEIGHT = 1

    def initialize(input)
      @tasks = parse(input)
    end

    def call
      @tasks.sum do |task|
        inverse = [[task[1][1], -task[0][1]],
                   [-task[1][0], task[0][0]]]

        det = task[0][0] * task[1][1] - task[0][1] * task[1][0]

        res = 0
        if det != 0
          scalar0 = inverse[0][0] * task[0][2] + inverse[0][1] * task[1][2]
          scalar1 = inverse[1][0] * task[0][2] + inverse[1][1] * task[1][2]
          if (scalar0 % det).zero? && (scalar1 % det).zero?
            a, b = [scalar0 / det, scalar1 / det]
            if a >= 0 && b >= 0
              res = a * A_WEIGHT + b * B_WEIGHT
            end
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
        [[a1, b1, x + ADD], [a2, b2, y + ADD]]
      end
    end
  end
end
