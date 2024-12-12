module Day12
  class Part2
    SIDES = {
      north: [:east, :west],
      south: [:east, :west],
      east: [:north, :south],
      west: [:north, :south],
    }

    def initialize(input)
      @board = input.split("\n").map { _1.chars }
    end

    def call
      components_set.sum do |component|
        calc_sides(component) * component.count
      end
    end

    private

    def components_set
      unprocessed_coords = (0..@board.size - 1).to_a.product((0..@board[0].size - 1).to_a).to_set
      components = []

      while unprocessed_coords.any?
        point = unprocessed_coords.first
        unprocessed_coords.delete(point)

        component = Set.new([point])
        queue = [point]
        while e = queue.pop
          neighbors(e, unprocessed_coords).each do |neighbor|
            queue << neighbor
            component << neighbor
            unprocessed_coords.delete(neighbor)
          end
        end
        components << component
      end

      components
    end

    def calc_sides(component)
      queue = [component.first]
      index = 0
      boundaries = {}
      processed = Set.new

      # Run the traversal algorithm.
      # If we find a boundary point for a certain direction, we assign a new index(inc) to it (for example [1,3] => { north: 12 })
      # then check and mark all points on the line perpendicular to the direction the same index
      # (for example [1,4] => { north: 12 }, [1,5] => { north: 12 } etc)
      # When all boundary point are marked we just see max index
      while point = queue.shift
        next if processed.include?(point)
        processed << point
        boundaries[point] ||= {}

        fill_side = ->(mv_direction, check_direction) do
          side = method(mv_direction).(point)

          while side && component.include?(side)
            break if component.include?(method(check_direction).(side))

            boundaries[side] ||= {}
            boundaries[side][check_direction] = index
            side = method(mv_direction).(side)
          end
        end

        check_and_fill = -> (check_direction) do
          check_point = method(check_direction).(point)

          if component.include? check_point
            queue << check_point
            boundaries[point][check_direction] = 0
          else
            unless boundaries[point][check_direction]
              boundaries[point][check_direction] = (index += 1)

              SIDES[check_direction].each do |direction|
                fill_side.(direction, check_direction)
              end
            end
          end
        end

        [:north, :east, :south, :west].each do |direction|
          check_and_fill.(direction)
        end
      end
      index
    end

    def neighbors(point, unprocessed)
      [north(point), south(point), east(point), west(point)].filter do |n|
        unprocessed.include?(n) && value(n) == value(point)
      end
    end

    def north(point) = [point[0] - 1, point[1]]

    def south(point) = [point[0] + 1, point[1]]

    def east(point) = [point[0], point[1] + 1]

    def west(point) = [point[0], point[1] - 1]

    def value(point) = @board[point[0]][point[1]]
  end
end

test_data = <<~DATA
  AAAA
  BBCD
  BBCC
  EEEC
DATA
fail 'error 1' unless Day12::Part2.new(test_data).call == 80

test_data = <<~DATA
  OOOOO
  OXOXO
  OOOOO
  OXOXO
  OOOOO
DATA
fail 'error 2' unless Day12::Part2.new(test_data).call == 436

test_data = <<~DATA
  EEEEE
  EXXXX
  EEEEE
  EXXXX
  EEEEE
DATA
fail 'error 3' unless Day12::Part2.new(test_data).call == 236

test_data = <<~DATA
  AAAAAA
  AAABBA
  AAABBA
  ABBAAA
  ABBAAA
  AAAAAA
DATA
fail 'error 4' unless Day12::Part2.new(test_data).call == 368

test_data = <<~DATA
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
DATA
fail 'error 5' unless Day12::Part2.new(test_data).call == 1206
