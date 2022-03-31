# frozen_string_literal: true

module LAB
  class TableBuilder
    class << self
      def build
        Brewer.each do |brewer|
          puts "Brewer: #{brewer.name}, total points: #{brewer.total_points}"
        end
      end
    end
  end
end
