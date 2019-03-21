module LAB
  class DataLoader
    class << self
      def data_glob
        File.join(File.dirname(__FILE__), '..', '..', 'data', '*.yaml')
      end

      def competitions_for_table
        competitions.reject { |data| data['exclude_from_table'] }
      end

      def competitions_for_roll
        competitions.reject { |data| data['exclude_from_roll_of_honour'] }
      end

      def brewers_for_table
        brewers(competitions_for_table)
      end

      def sorted_brewers_for_table
        sorted_brewers(brewers_for_table)
      end

      def new_brewer_data
        {
          'flight' => { 'gold' => [], 'silver' => [], 'bronze' => [], '4th' => [], 'HM' => [] },
          'bos'    => { 'gold' => [], 'silver' => [], 'bronze' => [], '4th' => [], 'HM' => [] }
        }
      end

      def append_medal_counts!(brewer, medals)
        LAB.sections.each do |section|
          medal_counts = medals[section]

          next unless medal_counts

          medal_counts.each do |medal, medaling_beers|
            brewer[section][medal] += medaling_beers
          end
        end
      end

      def append_score!(data)
        data['score'] = calc_score(data)
      end

      private

      def competitions
        @competitions ||= begin
          Dir[data_glob].map     { |file| YAML.load(File.read(file)) }
                        .sort_by { |data| Date.parse(data['date']) }
                        .reverse
        end
      end

      def brewers(competitions)
          memo = {}

          foreach_competition_winner(competitions) do |data|
            brewer = memo[data['name']] ||= new_brewer_data.dup

            append_medal_counts!(brewer, data)
          end

          memo.each { |_brewer, data| append_score!(data) }

          memo
      end

      def sorted_brewers(brewers)
        LAB::Sorter.new(brewers).sort_and_rank
      end

      def calc_score(medals)
        score = 0

        medals.each do |section, medal_counts|
          next unless medal_counts.respond_to?(:each)
          
          medal_counts.each do |place, medaling_beers|
            score += (SCORES.fetch(section).fetch(place, 0) * medaling_beers.count)
          end
        end

        score
      end

      def foreach_competition_winner(competitions)
        competitions.each do |competition|
          competition['winners'].each do |data|
            yield(data)
          end
        end
      end
    end
  end
end
