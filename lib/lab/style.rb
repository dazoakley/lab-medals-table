# frozen_string_literal: true

module LAB
  class Style < Sequel::Model
    many_to_one :guideline, class: :Guideline
  end
end
