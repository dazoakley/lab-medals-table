# frozen_string_literal: true

module LAB
  class Brewer < Sequel::Model
    one_to_many :beers

    def total_points
      beers.map(&:total_points).sum
    end

    def medal_counts
      counts = {}

      Result.rounds.each do |round|
        %w[gold silver bronze].each do |place|
          counts[round] ||= {}
          counts[round][place] = 0
        end
      end

      beers.each do |beer|
        beer.results.each do |result|
          counts[result.round][result.place] += 1
        end
      end

      counts
    end

    def sorter
      sorter_val = [total_points]
      counts = medal_counts

      Result.rounds.each do |round|
        %w[gold silver bronze].each do |place|
          sorter_val << counts[round][place]
        end
      end

      sorter_val
    end
  end
end
