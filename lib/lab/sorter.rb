module LAB
  class Sorter
    attr_reader :brewers

    def initialize(brewers)
      @brewers = brewers
    end

    def sort_and_rank
      @rank ||= begin
        memo = []

        ranked_names.each_with_index do |name, index|
          brewer = brewers.find { |b| b.name == name }

          if index == 0
            memo << [brewer, index + 1]
          else
            prev_brewer_name = ranked_names[index - 1]
            prev_brewer      = brewers.find { |b| b.name == prev_brewer_name }

            comparison  = brewer.sorter <=> prev_brewer.sorter
            rank        = comparison.zero? ? '=' : index + 1

            memo << [brewer, rank]
          end
        end

        memo
      end
    end

    def ranked_names
      @ranked_names ||= brewers.sort_by do |brewer|
        brewer.sorter
      end.reverse.map(&:name)
    end
  end
end
