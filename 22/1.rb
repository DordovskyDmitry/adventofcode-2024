module Day22
  class Part1
    def initialize(test_data, count)
      @numbers = test_data.split("\n").map(&:to_i)
      @count = count
    end

    def call
      @numbers.sum do |secret|
        @count.times { secret = evolve(secret) }
        secret
      end
    end

    private

    def evolve(secret)
      mix(secret * 64, secret).then { prune _1 }.
        then { |s| mix(s/32, s) }.then { prune _1 }.
        then { |s| mix(s * 2048, s) }.then { prune _1 }
    end

    def mix(a, b) = a ^ b

    def prune(a) = a % 16777216
  end
end

test_data = <<~DATA
  1
  10
  100
  2024
DATA

fail 'error' unless Day22::Part1.new(test_data, 2000).call == 37327623
