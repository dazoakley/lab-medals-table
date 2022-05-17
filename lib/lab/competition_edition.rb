# frozen_string_literal: true

module LAB
  class CompetitionEdition < Sequel::Model
    many_to_one :competition
    many_to_one :location
    many_to_one :guideline
    one_to_many :results
    many_through_many :brewers, [
      %i[results competition_edition_id beer_id],
      %i[beers id brewer_id]
    ]

    def points_eligible?
      competition.points_eligible?
    end

    def table_display_name
      "#{date.year} - #{competition.abbreviated_name}"
    end

    def roll_of_honour_display_name
      "#{competition.name}, #{date.year} - #{location.name}"
    end

    def best_of_show_winners?
      best_of_show_winners.any?
    end

    def best_of_show_winners
      @best_of_show_winners ||= LAB::Result.best_of_show_results_for_competition_edition(self)
    end

    def flight_winners?
      flight_winners.any?
    end

    def flight_winners
      @flight_winners ||= LAB::Result.flight_results_for_competition_edition(self)
    end

    def winning_brewers
      brewers.uniq
    end
  end
end
