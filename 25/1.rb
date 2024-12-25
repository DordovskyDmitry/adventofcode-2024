module Day25
  class Part1

    def initialize(input)
      @locks = []
      @keys = []

      input.split("\n\n").each do |data|
        board = data.split("\n").map { _1.split('') }
        if board[0].all? { _1 == '#' }
          @locks << board
        else
          @keys << board
        end
      end
    end

    def call
      locks_data = @locks.map { |lock| [lock.size, heights(lock)] }
      keys_data = @keys.map { |key| [key.size, heights(key)] }

      locks_data.product(keys_data).count do |(lock_data, key_data)|
        fit?(lock_data, key_data)
      end
    end

    private

    def fit?(lock_data, key_data)
      return false unless lock_data[0] == key_data[0]

      lock_data[1].each_with_index.all? do |e, i|
        e + key_data[1][i] + 2 <= lock_data[0]
      end
    end

    def heights(board)
      board.transpose.map do |line|
        line.count { _1 == '#' } - 1
      end
    end
  end
end

test_data = <<~DATA
  #####
  .####
  .####
  .####
  .#.#.
  .#...
  .....

  #####
  ##.##
  .#.##
  ...##
  ...#.
  ...#.
  .....

  .....
  #....
  #....
  #...#
  #.#.#
  #.###
  #####

  .....
  .....
  #.#..
  ###..
  ###.#
  ###.#
  #####

  .....
  .....
  .....
  #....
  #.#..
  #.#.#
  #####
DATA

fail 'error 0' unless Day25::Part1.new(test_data).call == 3
