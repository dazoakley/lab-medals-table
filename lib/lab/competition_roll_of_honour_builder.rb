require 'titleize'

module LAB
  class CompetitionRollOfHonourBuilder
    attr_reader :comp

    BOS_POS = {
      'gold'   => '1st',
      'silver' => '2nd',
      'bronze' => '3rd'
    }.freeze

    def initialize(comp)
      @comp = comp
    end

    def build
      [
        competition_title,
        '<dl>',
        "<dd>Guidelines</dd><dt>#{comp['guidelines']}</dt>",
        best_of_show_section,
        flight_section,
        '</dl>'
      ].compact.join("\n")
    end

    def best_of_show_winners
      @bos ||= begin
                 bos = {}

                 comp['winners'].select { |winner| winner['bos'] }
                                .sort_by { |winner| medal_to_bos_place(winner[0]) }
                                .reverse
                                .each do |winner|
                                  winner['bos'].each do |medal, beer|
                                    bos[medal_to_bos_place(medal)] = { 'brewer' => winner['name'], 'beer' => beer.first }
                                  end
                                end

                 bos
               end
    end

    def flight_winners
      @flight ||= begin
                    flight = {}

                    comp['winners'].select { |winner| winner['flight'] }
                                   .sort_by { |winner| medal_to_bos_place(winner[0]) }
                                   .reverse
                                   .each do |winner|
                                     winner['flight'].each do |medal, beers|
                                       beers.each do |beer|
                                         flight[medal] ||= []
                                         flight[medal] << { 'brewer' => winner['name'], 'beer' => beer }
                                       end
                                     end
                                   end

                    flight.each do |_medal, beers|
                      beers.sort_by! do |winner|
                        [winner['brewer'], winner['beer']['name'].to_s]
                      end
                    end

                    flight
                  end
    end

    private

    def medal_to_bos_place(medal)
      BOS_POS[medal] ? BOS_POS[medal] : medal
    end

    def brewer_and_beer_line(beer)
      str = beer['brewer'].dup
      str << " (Asst. Brewer: #{beer.dig('beer', 'asst_brewer')})" if beer.dig('beer', 'asst_brewer')
      str << " - #{beer.dig('beer', 'name')}"
      str << ", (#{beer.dig('beer', 'style')})" if beer.dig('beer', 'style')
      str
    end

    def competition_title
      html = "<h4>#{comp['full_name']}, #{comp['year']}"
      html << " - #{comp['location']}" if comp['location']
      html << '</h4>'
      html
    end

    def best_of_show_section
      return unless best_of_show_winners.any?

      html = ['<dt>Best of Show</dt>']
      best_of_show_winners.each do |place, detail|
        html << "<dd>#{place} - #{brewer_and_beer_line(detail)}</dd>"
      end

      html.join("\n")
    end

    def flight_section
      return unless flight_winners.any?

      html = []

      flight_winners.each do |medal, winners|
        html << "<dt>#{medal.titleize} Medals</dt>"

        winners.each do |winner|
          html << "<dd>#{brewer_and_beer_line(winner)}</dd>"
        end
      end

      html.join("\n")
    end
  end
end
