# frozen_string_literal: true

module LAB
  class Brewer < Sequel::Model
    one_to_many :beers
    many_through_many :results, [
      %i[beers brewer_id id],
      %i[results beer_id id]
    ]

    def self.sorted_and_ranked
      LAB::Sorter.new(LAB::Brewer.all).sort_and_rank
    end

    def total_points
      beers.map(&:total_points).sum
    end

    def total_points_for_competition_edition(competition_edition)
      score = 0

      results.each do |result|
        next unless result.competition_edition_id == competition_edition.id

        score += result.score
      end

      score
    end

    def total_medals
      count = 0

      Result.rounds.each do |round|
        Result.gold_silver_bronze_places.each do |place|
          count += medal_counts[round][place]
        end
      end

      count
    end

    def medal_counts
      @medal_counts ||= begin
        counts = empty_medal_counts

        results.each do |result|
          next unless result.points_eligible?

          counts[result.round][result.place] += 1
        end

        counts
      end
    end

    def medal_counts_for_competition_edition(competition_edition)
      counts = empty_medal_counts

      results.each do |result|
        next unless result.competition_edition_id == competition_edition.id

        counts[result.round][result.place] += 1
      end

      counts
    end

    def sorter
      sorter_val = [total_points]

      Result.rounds.each do |round|
        Result.gold_silver_bronze_places.each do |place|
          sorter_val << medal_counts[round][place]
        end
      end

      sorter_val
    end

    private

    def empty_medal_counts
      counts = {}

      Result.rounds.each do |round|
        Result.places.each do |place|
          counts[round] ||= {}
          counts[round][place] = 0
        end
      end

      counts
    end
  end
end
