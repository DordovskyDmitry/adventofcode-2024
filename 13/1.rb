module Day13
  class Part1
    MAX_ROUNDS_PER_BUTTON = 100
    A_WEIGHT = 3
    B_WEIGHT = 1

    def initialize(input)
      @tasks = parse(input)
    end

    def call
      @tasks.sum do |task|
        solutions = []
        max_a = [task[0][2] / task[0][0], task[1][2] / task[1][0], MAX_ROUNDS_PER_BUTTON].min
        max_b = [task[0][2] / task[0][1], task[1][2] / task[1][1], MAX_ROUNDS_PER_BUTTON].min

        (0..max_a).each do |a|
          if (task[0][2] - a * task[0][0]) % task[0][1] == 0
            b = (task[0][2] - a * task[0][0]) / task[0][1]
            next if b > max_b

            if a * task[1][0] + b * task[1][1] == task[1][2]
              solutions << [a, b]
            end
          end
        end
        solutions.map { |(a, b)| a * A_WEIGHT + b * B_WEIGHT }.min.to_i
      end
    end

    private

    def parse(input)
      input.split("\n\n").map do |task|
        a_line, b_line, prize_line = task.split("\n")
        a1, a2 = a_line.match(/Button A: X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
        b1, b2 = b_line.match(/Button B: X\+(\d+), Y\+(\d+)/).captures.map(&:to_i)
        x, y = prize_line.match(/Prize: X=(\d+), Y=(\d+)/).captures.map(&:to_i)
        [[a1, b1, x], [a2, b2, y]]
      end
    end
  end
end

test_data = <<~DATA
  Button A: X+94, Y+34
  Button B: X+22, Y+67
  Prize: X=8400, Y=5400

  Button A: X+26, Y+66
  Button B: X+67, Y+21
  Prize: X=12748, Y=12176

  Button A: X+17, Y+86
  Button B: X+84, Y+37
  Prize: X=7870, Y=6450

  Button A: X+69, Y+23
  Button B: X+27, Y+71
  Prize: X=18641, Y=10279
DATA

fail 'error' unless Day13::Part1.new(test_data).call == 480
