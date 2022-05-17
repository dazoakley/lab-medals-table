# frozen_string_literal: true

module LAB
  class Guideline < Sequel::Model
    one_to_many :styles
    one_to_many :competition_editions
  end
end
