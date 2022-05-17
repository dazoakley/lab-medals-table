# frozen_string_literal: true

require 'csv'

module LAB
  class CsvExportBuilder
    class << self
      def build
        LAB::CompetitionEdition.each do |competition_edition|
          bos_medals = {}

          competition_edition.best_of_show_winners.each do |result|
            bos_medals[result.beer_id] = result.place
          end

          competition_edition.flight_winners.each do |result|
            csv_data << [
              competition_edition.date.year,
              competition_edition.competition.name,
              competition_edition.guideline.name,
              result.beer.brewer.name,
              result.beer.name,
              result.style.name || result.style.number,
              result.style.number || result.style.name,
              result.place,
              bos_medals[result.beer_id]
            ]
          end
        end

        generate_csv
      end

      private

      def generate_csv
        headers = [
          'Year',
          'Competition',
          'Guidelines',
          'Brewer',
          'Beer',
          'Style Name',
          'Style Code',
          'Flight Medal',
          'BOS Medal'
        ]

        CSV.generate do |csv|
          csv << headers
          csv_data.each do |row|
            csv << row
          end
        end
      end

      def csv_data
        @csv_data ||= []
      end
    end
  end
end
