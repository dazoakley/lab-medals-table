# frozen_string_literal: true

require 'erb'

module LAB
  class TableBuilder
    class << self
      def build
        @competition_editions = LAB::CompetitionEdition.reverse(:date).all.select(&:points_eligible?)

        template = ERB.new(File.read(File.join(__dir__, 'table.html.erb')), trim_mode: '>')
        template.result(binding)
      end
    end
  end
end
