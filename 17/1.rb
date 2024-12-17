module Day17
  class Part1
    def self.call(input)
      registers_data, program_data = input.split("\n\n")
      registers_data = registers_data.split("\n")

      registers = %w[A B C].each_with_index.reduce({}) do |acc, (l, i)|
        v = registers_data[i].match(/Register #{l}: (\d+)/).captures.first.to_i
        acc.merge(l.to_sym => v)
      end

      program = program_data.scan(/(\d+)/).flatten.map(&:to_i)

      new(program, registers).call.join(',')
    end

    def initialize(program, registers)
      @program, @registers = program, registers
    end

    def call
      output = []
      instruction_pointer = 0

      while @program[instruction_pointer]
        case @program[instruction_pointer]
        when 0
          @registers[:A] /= (2 ** combo_for(instruction_pointer))
        when 1
          @registers[:B] ^= literal_for(instruction_pointer)
        when 2
          @registers[:B] = combo_for(instruction_pointer) % 8
        when 3
          unless @registers[:A].zero?
            instruction_pointer = literal_for(instruction_pointer) - 2 # to compensate +2 at the end
          end
        when 4
          @registers[:B] ^= @registers[:C]
        when 5
          output << combo_for(instruction_pointer) % 8
        when 6
          @registers[:B] = @registers[:A] / (2 ** combo_for(instruction_pointer))
        when 7
          @registers[:C] = @registers[:A] / (2 ** combo_for(instruction_pointer))
        else
          break
        end

        instruction_pointer += 2
      end

      output
    end

    private

    def combo_for(instruction_pointer)
      operand = @program[instruction_pointer + 1]

      return operand if operand < 4
      return @registers[:A] if operand == 4
      return @registers[:B] if operand == 5
      return @registers[:C] if operand == 6

      fail 'invalid operand'
    end

    def literal_for(instruction_pointer)
      @program[instruction_pointer + 1]
    end
  end
end

test_data = <<~DATA
  Register A: 10
  Register B: 0
  Register C: 0

  Program: 5,0,5,1,5,4
DATA

fail 'error 1' unless Day17::Part1.call(test_data) == '0,1,2'

test_data = <<~DATA
  Register A: 2024
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
DATA

fail 'error 2' unless Day17::Part1.call(test_data) == '4,2,5,6,7,7,7,7,3,1,0'

test_data = <<~DATA
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
DATA

fail 'error 3' unless Day17::Part1.call(test_data) == '4,6,3,5,6,3,5,2,1,0'
