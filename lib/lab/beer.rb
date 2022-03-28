# frozen_string_literal: true

module LAB
  class Beer < Sequel::Model
    many_to_one :brewer
    many_to_one :assistant_brewer, class: :Brewer
    one_to_many :results

    def total_points
      results.map(&:score).sum
    end
  end
end
