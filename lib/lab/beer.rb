# frozen_string_literal: true

module LAB
  class Beer < Sequel::Model
    many_to_one :brewer
    many_to_one :assistant_brewer, class: :Brewer
    one_to_many :results

    def total_points
      points_eligible_results.map(&:score).sum
    end

    def points_eligible_results
      LAB::Result
        .where(beer_id: id)
        .join(:competition_editions, id: :competition_edition_id)
        .join(:competitions, [%i[id competition_id], [:points_eligible, true]])
    end
  end
end
