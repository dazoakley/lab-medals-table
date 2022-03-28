# frozen_string_literal: true

module LAB
  class Result < Sequel::Model
    many_to_one :beer
    many_to_one :competition_edition
    many_to_one :style

    def validate
      super
      errors.add(:type, "must be one of #{Result.result_types}") unless Result.result_types.include?(type)
      errors.add(:place, "must be one of #{Result.places}") unless Result.places.include?(place)
    end

    def self.result_types
      %w[flight bos]
    end

    def self.places
      %w[gold silver bronze 4th HM]
    end
  end
end
