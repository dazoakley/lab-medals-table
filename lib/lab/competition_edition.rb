# frozen_string_literal: true

module LAB
  class CompetitionEdition < Sequel::Model
    many_to_one :competitions
    many_to_one :locations
  end
end
