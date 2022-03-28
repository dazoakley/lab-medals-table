# frozen_string_literal: true

module LAB
  class Brewer < Sequel::Model
    one_to_many :beers
  end
end
