module LAB
  class Sorter
    attr_reader :brewers

    def initialize(brewers)
      @brewers = brewers
    end

    def sort_and_rank
      memo = []

      ranked_names.each_with_index do |name, index|
        if index == 0
          memo << [name, index + 1]
        else
          score      = brewers[name]['score']
          prev_score = brewers[ranked_names[index - 1]]['score']
          rank       = score == prev_score ? '=' : index + 1

          memo << [name, rank]
        end
      end

      memo
    end

    def ranked_names
      @ranked_names ||= begin
        brewers.sort_by do |_brewer, data|
          sort_order = [data['score']]

          LAB.sections.reverse.each do |section|
            LAB.medals.each do |medal|
              sort_order << data.fetch(section, {}).fetch(medal, 0)
            end
          end

          sort_order
        end.reverse.map(&:first)
      end
    end
  end
end
