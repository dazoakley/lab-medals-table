# frozen_string_literal: true

module LAB
  class CompetitionEdition < Sequel::Model
    many_to_one :competition
    many_to_one :location
    many_to_one :guideline
    one_to_many :results

    def self.points_eligible
      join(:competitions, [%i[id competition_id], [:points_eligible, true]])
    end

    def table_display_name
      "#{date.year} - #{competition.abbreviated_name}"
    end
  end
end
