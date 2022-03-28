# frozen_string_literal: true

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
      SCORES[round][place] || 0
    end

    def self.rounds
      %w[bos flight]
    end

    def self.places
      %w[gold silver bronze 4th HM]
    end
  end
end
