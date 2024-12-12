module Day12
  class Part1
    def initialize(input)
      @board = input.split("\n").map { _1.chars }
    end

    def call
      unprocessed_coords = (0..@board.size - 1).to_a.product((0..@board[0].size - 1).to_a).to_set
      components = []

      while unprocessed_coords.any?
        point = unprocessed_coords.first
        unprocessed_coords.delete(point)

        # build a new component: [array of coords, perimeter]
        # filter neighbors from the same component
        # and update perimeter based on their neighbors count already in the component
        # and then check neighbors of neighbors and repeat until the component is full (no same free members)
        component = [Set.new([point]), 4]
        queue = [point]
        while e = queue.pop
          neighbors(e, unprocessed_coords).each do |neighbor|
            queue << neighbor

            ns_count = processed_neighbors_count(neighbor, component.first)
            component.first << neighbor
            component[1] = component[1] + 4 - 2 * ns_count # 4 initial boundaries - erased(2 because two fences between 2 simple points)
            unprocessed_coords.delete(neighbor)
          end
        end
        components << component
      end

      components.sum { |component| component[0].size * component[1] }
    end

    private

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

    def processed_neighbors_count(point, points)
      [north(point), south(point), east(point), west(point)].count { points.include?(_1) }
    end
  end
end

test_data = <<~DATA
  AAAA
  BBCD
  BBCC
  EEEC
DATA

fail 'error' unless Day12::Part1.new(test_data).call == 140

test_data = <<~DATA
  OOOOO
  OXOXO
  OOOOO
  OXOXO
  OOOOO
DATA

fail 'error' unless Day12::Part1.new(test_data).call == 772

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

fail 'error' unless Day12::Part1.new(test_data).call == 1930
