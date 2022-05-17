require 'csv'

module LAB
  class PointsOverTimeBuilder
    class << self
      def build
        CSV.generate do |csv|
          csv << ['Brewer'] + LAB::CompetitionEdition.map(&:date)
          brewer_points_over_time.each do |brewer, scores|
            csv << ([brewer] + scores)
          end
        end
      end

      def brewer_points_per_competition_edition
        points_per_comp_edition = {}

        LAB::Brewer.order(:name).each do |brewer|
          next if brewer.total_points.zero?

          points_per_comp_edition[brewer.name] = []
        end

        LAB::CompetitionEdition.each do |competition_edition|
          winning_brewer_names = competition_edition.winning_brewers.map(&:name)

          points_per_comp_edition.each do |name, points_arry|
            points_arry << if winning_brewer_names.include?(name)
                             brewer = LAB::Brewer.find(name:)
                             brewer.total_points_for_competition_edition(competition_edition)
                           else
                             0
                           end
          end
        end

        points_per_comp_edition
      end

      def brewer_points_over_time
        brewer_points_per_competition_edition.each do |_brewer, points_arry|
          points_arry.each_with_index do |points, index|
            points_arry[index] =  index.zero? ? points : points_arry[index - 1] + points
          end
        end
      end
    end
  end
end
