# frozen_string_literal: true

module LAB
  class Result < Sequel::Model
    many_to_one :beer
    many_to_one :competition_edition
    many_to_one :style

    # def validate
    #   super
    #   validates_includes Result.result_types, :type
    #   validates_includes Result.places, :place
    # end

    def self.result_types
      %w[flight bos]
    end

    def self.places
      %w[gold silver bronze 4th HM]
    end
  end
end
