module Day9
  class Part1
    def initialize(input)
      @input = input
    end

    def call
      map_to_file_system.then(&method(:compact)).then(&method(:checksum))
    end

    private

    def map_to_file_system
      @input.each_char.with_index.reduce([]) do |agg, (c, i)|
        if i.even?
          agg + [i / 2] * c.to_i
        else
          agg + [nil] * c.to_i
        end
      end
    end

    def compact(system)
      j = system.length - 1

      system.each_with_index do |w, i|
        while system[j].nil?
          j -= 1
        end
        break if i >= j

        if w.nil?
          system[i], system[j] = system[j], system[i]
        end
      end

      system
    end

    def checksum(system)
      system.each_with_index.sum do |w, i|
        w.nil? ? 0 : w * i
      end
    end
  end
end

fail 'error' unless Day9::Part1.new('12345').call == 60
fail 'error' unless Day9::Part1.new('2333133121414131402').call == 1928
