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
          if index == 0
            memo << [name, index + 1]
          else
            prev_brewer = ranked_names[index - 1]

            curr_score  = brewers.find { |b| b.name == name }.sorter
            prev_score  = brewers.find { |b| b.name == prev_brewer }.sorter

            comparison  = curr_score <=> prev_score
            rank        = comparison == 0 ? '=' : index + 1

            memo << [name, rank]
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
