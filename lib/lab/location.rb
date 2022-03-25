# frozen_string_literal: true

module LAB
  class Location < Sequel::Model
    one_to_many :competition_editions
  end
end
