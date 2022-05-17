# frozen_string_literal: true

module LAB
  class Competition < Sequel::Model
    one_to_many :competition_editions

    def points_eligible?
      points_eligible
    end
  end
end
