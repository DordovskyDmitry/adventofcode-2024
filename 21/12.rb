module Day21
  class Part12

    NUMERIC_PAD = {
      '1' => [2, 0],
      '2' => [2, 1],
      '3' => [2, 2],
      '4' => [1, 0],
      '5' => [1, 1],
      '6' => [1, 2],
      '7' => [0, 0],
      '8' => [0, 1],
      '9' => [0, 2],
      '0' => [3, 1],
      'A' => [3, 2],
    }

    DIRECTIONAL_PAD = {
      '^' => [0, 1],
      '>' => [1, 2],
      'v' => [1, 1],
      '<' => [1, 0],
      'A' => [0, 2],
    }

    def initialize(input, deep = 2)
      @puzzles = input.split("\n").map { _1.chars }
      @deep = deep
    end

    def call
      @calc_chunk = {}
      @puzzles.sum do |puzzle|
        numeric_from = 'A'
        numeric_paths = puzzle.reduce([]) do |agg, destination|
          paths = possible_paths(numeric_from, destination, NUMERIC_PAD)
          numeric_from = destination
          agg.empty? ? paths : agg.product(paths).map { |a, b| a + b }
        end

        numeric_paths.map { |numeric_path| calc_chunk(numeric_path, @deep) }.min * number_from(puzzle)
      end
    end

    private

    def calc_chunk(chunk, deep)
      @calc_chunk[[chunk, deep]] ||= begin
        if deep == 1
          return @calc_chunk[[chunk, deep]] = directional_instructions(chunk).map(&:length).min
        end

        directional_instructions(chunk).map do |possible_path|
          possible_path.chunk_while { _1 != 'A' }.
            sum { calc_chunk(_1, deep - 1) }
        end.min
      end
    end

    def directional_instructions(chunk)
      from = 'A'
      chunk.reduce([]) do |acc, to|
        paths = possible_paths(from, to, DIRECTIONAL_PAD)
        from = to
        acc.empty? ? paths : acc.product(paths).map { |a, b| a + b }
      end
    end

    def possible_paths(from, to, pad)
      from_pos = pad[from]
      to_pos = pad[to]

      path_steps = ['^'] * [from_pos[0] - to_pos[0], 0].max +
        ['<'] * [from_pos[1] - to_pos[1], 0].max +
        ['>'] * [to_pos[1] - from_pos[1], 0].max +
        ['v'] * [to_pos[0] - from_pos[0], 0].max

      path_steps.permutation.uniq.
        filter { |path| check_steps(from_pos, path, pad) }.
        map { _1 + ['A'] }
    end

    def check_steps(from, path, pad)
      current_pos = from.clone
      path.all? do |step|
        case step
        when '^'
          current_pos[0] -= 1
        when 'v'
          current_pos[0] += 1
        when '>'
          current_pos[1] += 1
        when '<'
          current_pos[1] -= 1
        end

        pad.invert[current_pos]
      end
    end

    def number_from(puzzle)
      puzzle.join.to_i
    end
  end
end

<<~KEYPADS
  +---+---+---+
  | 7 | 8 | 9 |
  +---+---+---+
  | 4 | 5 | 6 |
  +---+---+---+
  | 1 | 2 | 3 |
  +---+---+---+
      | 0 | A |
      +---+---+

      +---+---+
      | ^ | A |
  +---+---+---+
  | < | v | > |
  +---+---+---+
KEYPADS

test_data = <<~DATA
  3
DATA
fail 'error' unless Day21::Part12.new(test_data, 2).call == 36

test_data = <<~DATA
  029A
  980A
  179A
  456A
  379A
DATA

fail 'error2' unless Day21::Part12.new(test_data, 2).call == 126384
