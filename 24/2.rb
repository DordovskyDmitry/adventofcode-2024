# I didn't get firstly the formula, so I printed all unwrappings for each bit formula to different levels (4 is enough)
# Then I saw the pattern:
# 1. All z## have XOR operator
# 2. To reveal right wire to change we can look at the fourth line of #print_wire_deps for the next index
# 3. Find z38 by finding first broken bit
# 4. Look at the third line broken pattern

# Note: I used topological sorting to determine the calc order of dependent wires

require_relative '../utils/tsort_hash'

module Day24
  class Part2
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
      rules = @rules
      dependencies = @dependencies

      p '----- FIX z08 --------'
      key1 = 'z08'
      key2 = 'cdj'
      rules = rules.merge(key2 => rules[key1], key1 => rules[key2])
      dependencies = dependencies.merge(key2 => dependencies[key1], key1 => dependencies[key2])

      p '----- FIX z16 --------'
      key1 = 'z16'
      key2 = 'mrb'
      rules = rules.merge(key2 => rules[key1], key1 => rules[key2])
      dependencies = dependencies.merge(key2 => dependencies[key1], key1 => dependencies[key2])

      p '----- FIX z32 --------'
      key1 = 'z32'
      key2 = 'gfm'
      rules = rules.merge(key2 => rules[key1], key1 => rules[key2])
      dependencies = dependencies.merge(key2 => dependencies[key1], key1 => dependencies[key2])

      p '----- FIX z38 --------'

      broken = indices(dependencies, rules, @values).first
      print_wire_deps(broken..broken+1, dependencies, rules)

      key1 = 'qjd'
      key2 = 'dhm'
      rules = rules.merge(key2 => rules[key1], key1 => rules[key2])
      dependencies = dependencies.merge(key2 => dependencies[key1], key1 => dependencies[key2])
      print_wire_deps(broken..broken+1, dependencies, rules)

      p '---------- RESULT ----------'

      p res: %w[z32 gfm qjd dhm z16 mrb z08 cdj].sort.join(',')
    end

    def print_recursive_formula(dependencies, rules, reg, deep)
      deps = dependencies[reg]&.sort

      if deps && deep != 0
        "(#{print_recursive_formula(dependencies, rules, deps[0], deep - 1)} #{rules[reg]} #{print_recursive_formula(dependencies, rules, deps[1], deep - 1)})"
      else
        reg
      end
    end

    def print_wire_deps(range, dependencies, rules)
      range.each do |i|
        reg = sprintf("z%2.2d", i)
        p print_recursive_formula(dependencies, rules, reg, 0)
        p print_recursive_formula(dependencies, rules, reg, 1)
        p print_recursive_formula(dependencies, rules, reg, 2)
        p print_recursive_formula(dependencies, rules, reg, 3)
      end
    end

    def value(t, values)
      values.filter { |k, _| k.start_with?(t) }.sort.reverse.map { _1[1] }.join
    end

    def recalc_values(dependencies, rules, values)
      values = values.clone

      TSortHash[dependencies].tsort.each do |w|
        next if values[w]
        values[w] = dependencies[w].map { values[_1] }.reduce(rules[w])
      end
      values
    end

    def indices(dependencies, rules, values)
      values = recalc_values(dependencies, rules, values)

      z_value = value('z', values)

      sum = (value('x', values).to_i(2) + value('y', values).to_i(2))
      bin_sum = sprintf("%045b", sum)

      if bin_sum.to_i(2) != z_value.to_i(2)
        (0..45).reduce([]) do |acc, i|
          if bin_sum.reverse[i] != z_value.reverse[i]
            acc << i
          else
            acc
          end
        end
      else
        []
      end
    end
  end
end
