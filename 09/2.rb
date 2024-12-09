require_relative '1'

module Day9
  class Part2 < Part1
    private

    def map_to_file_system
      @input.each_char.with_index.reduce([]) do |agg, (c, i)|
        next agg if c == '0'
        v = i.even? ? i / 2 : nil

        from = i == 0 ? 0 : agg[-1][1] + agg[-1][2]
        agg + [[v, from, c.to_i]]
      end
    end

    def compact(system)
      # work with reverted to insert to array and do not break pointer
      reverse_system = system.reverse

      i = reverse_system.length - 1
      j = 0

      while j < i
        # find value
        while reverse_system[j][0] == nil
          j += 1
        end

        # find empty spot
        while i >= 0 && (reverse_system[i][0] != nil || reverse_system[i][2] < reverse_system[j][2])
          i -= 1
        end

        # if no spot
        if i <= j
          j += 1
          i = reverse_system.length - 1
          next
        end

        # swap with dividing interval if necessary
        to_add = if reverse_system[i][2] - reverse_system[j][2] > 0
                   [[nil,
                     reverse_system[i][1] + reverse_system[i][2] - reverse_system[j][2] + 1,
                     reverse_system[i][2] - reverse_system[j][2]]]
                 else
                   []
                 end
        to_add += [[reverse_system[j][0], reverse_system[i][1], reverse_system[j][2]]]

        reverse_system = reverse_system[0...i] + to_add + reverse_system[i + 1...]

        reverse_system[j][0] = nil
        j += 1
        i = reverse_system.length - 1
      end

      # map to the task format
      reverse_system.reverse.reduce([]) do |agg, (e, _, quantity)|
        agg + [e] * quantity
      end
    end
  end
end

fail 'error' unless Day9::Part2.new('2333133121414131402').call == 2858
