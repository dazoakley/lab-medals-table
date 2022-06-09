# frozen_string_literal: true

require 'titleize'

module LAB
  class Result < Sequel::Model
    many_to_one :beer
    many_to_one :competition_edition
    many_to_one :style

    SCORES = {
      'flight' => {
        'gold' => 10,
        'silver' => 5,
        'bronze' => 2.5
      },
      'bos' => {
        'gold' => 20,
        'silver' => 10,
        'bronze' => 5
      }
    }.freeze

    def validate
      super
      errors.add(:round, "must be one of #{Result.rounds}") unless Result.rounds.include?(round)
      errors.add(:place, "must be one of #{Result.places}") unless Result.places.include?(place)
    end

    def score
      return 0 unless points_eligible?

      provisional_score = SCORES[round][place] || 0

      if smaller_competition?
        provisional_score / 2
      else
        provisional_score
      end
    end

    def points_eligible?
      competition_edition.points_eligible?
    end

    def smaller_competition?
      competition_edition.smaller_competition?
    end

    def description_for_roll_of_honour
      desc = "#{place.titleize} - #{beer.brewer.name}"
      desc << " (Assistant Brewer: #{beer.assistant_brewer.name})" if beer.assistant_brewer
      desc << " - #{beer.name}"

      if style.number != 'NONE'
        desc << " (#{style.number}"
        desc << ": #{style.name}" if style.name && !style.name.empty?
        desc << ')'
      end

      desc
    end

    def self.best_of_show_results_for_competition_edition(competition_edition)
      where(competition_edition_id: competition_edition.id, round: 'bos')
        .sort_by { |result| Result.places.index(result.place) }
    end

    def self.flight_results_for_competition_edition(competition_edition)
      where(competition_edition_id: competition_edition.id, round: 'flight')
        .sort_by { |result| Result.places.index(result.place) }
    end

    def self.rounds
      %w[bos flight]
    end

    def self.places
      %w[gold silver bronze 4th HM]
    end

    def self.gold_silver_bronze_places
      %w[gold silver bronze]
    end
  end
end
