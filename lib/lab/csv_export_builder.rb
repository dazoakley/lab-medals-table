# frozen_string_literal: true

require 'csv'
require 'pry'

module LAB
  class CsvExportBuilder
    class << self
      def build
        competitions.each do |comp|
          year       = comp['year']
          name       = comp['full_name'] || comp['abbr_name']
          guidelines = comp['guidelines']

          comp['winners'].each do |winner|
            bos_medals = {}

            if winner['bos']
              winner['bos'].each do |medal, beers|
                bos_medals[beers.first['name']] = medal
              end
            end

            winner['flight'].each do |medal, beers|
              beers.each do |beer|
                csv_data << [
                  year,
                  name,
                  guidelines,
                  winner['name'],
                  beer['name'],
                  medal,
                  bos_medals[beer['name']]
                ]
              end
            end
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
          'Flight Medal',
          'BOS Medal'
        ]

        CSV.generate do |csv|
          csv << headers
          csv_data.sort_by { |row| row[0] }.each do |row|
            csv << row
          end
        end
      end

      def csv_data
        @csv_data ||= []
      end

      def competitions
        LAB::DataLoader.competitions_for_roll
      end
    end
  end
end
