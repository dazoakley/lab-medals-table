require 'csv'

module LAB
  class PointsOverTimeBuilder
    class << self
      def build
        data = build_data

        CSV.generate do |csv|
          csv << ['Brewer'] + competitions.map { |c| c['date'] }
          data.each do |brewer, scores|
            csv << ([brewer] + scores)
          end
        end
      end

      def build_data
        collate_timeline

        memo  = {}
        names = @timeline.last.keys.sort

        @timeline.each do |brewers|
          names.each do |name|
            memo[name] ||= []

            # binding.pry
            # exit

            memo[name] << (brewers.dig(name, 'score') || 0.0)
          end
        end

        memo
      end

      def collate_timeline
        @timeline   = []
        @total_data = {}

        competitions.each do |competition|
          single_comp = deep_copy(@total_data)

          competition['winners'].each do |data|
            brewer = single_comp[data['name']] ||= LAB::DataLoader.new_brewer_data.dup
            LAB::DataLoader.append_medal_counts!(brewer, data)
          end

          single_comp.each { |_brewer, data| LAB::DataLoader.append_score!(data) }

          @timeline << single_comp
          @total_data = deep_copy(single_comp)
        end
      end

      private

      def deep_copy(obj_to_copy)
        Marshal.load(Marshal.dump(obj_to_copy))
      end

      def competitions
        LAB::DataLoader.competitions_for_table.reverse
      end
    end
  end
end
