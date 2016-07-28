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
          prev_brewer = ranked_names[index - 1]

          curr_score  = ordering_data(name, brewers[name])
          prev_score  = ordering_data(prev_brewer, brewers[prev_brewer])

          comparison  = curr_score <=> prev_score
          rank        = comparison == 0 ? '=' : index + 1

          memo << [name, rank]
        end
      end

      memo
    end

    def ranked_names
      @ranked_names ||= begin
        brewers.sort_by do |brewer, data|
          ordering_data(brewer, data) + string_as_numers(brewer)
        end.reverse.map(&:first)
      end
    end

    private

    def string_as_numers(str)
      str.upcase.chars.map { |ch| -(ch.ord - 'A'.ord + 10) }
    end

    def ordering_data(_brewer, data)
      sort_order = [data['score']]

      LAB.sections.reverse.each do |section|
        LAB.medals.each do |medal|
          sort_order << data.fetch(section, {}).fetch(medal, []).count
        end
      end

      sort_order
    end
  end
end
