require 'titleize'

module LAB
  class CompetitionRollOfHonourBuilder
    attr_reader :comp

    BOS_POS = {
      'gold' => '1st',
      'silver' => '2nd',
      'bronze' => '3rd',
      '4th' => '4th',
      'HM' => '5th'
    }.freeze

    def initialize(comp)
      @comp = comp
    end

    def build
      [
        competition_title,
        '<dl>',
        "<dt>Guidelines</dt><dd>#{comp['guidelines']}</dd>",
        best_of_show_section,
        flight_section,
        '</dl>'
      ].compact.join("\n")
    end

    def best_of_show_winners
      @bos ||= begin
                 bos = {}

                 comp['winners'].select { |winner| winner['bos'] }
                                .each do |winner|
                                  winner['bos'].each do |medal, beer|
                                    bos[medal_to_bos_place(medal)] = { 'brewer' => winner['name'], 'beer' => beer.first }
                                  end
                                end

                 bos.sort_by { |medal, _beer| medal_to_bos_place(medal) }
                    .to_h
               end
    end

    def flight_winners
      @flight ||= begin
                    flight = {}

                    comp['winners'].select { |winner| winner['flight'] }
                                   .each do |winner|
                                     winner['flight'].each do |medal, beers|
                                       beers.each do |beer|
                                         flight[medal] ||= []
                                         flight[medal] << { 'brewer' => winner['name'], 'beer' => beer }
                                       end
                                     end
                                   end

                    flight
                      .sort_by { |medal, _beer| medal_to_bos_place(medal) }
                      .to_h
                      .each do |_medal, beers|
                        beers.sort_by! do |winner|
                          [winner['brewer'], winner['beer']['name'].to_s]
                        end
                      end
                  end
    end

    private

    def medal_to_bos_place(medal)
      BOS_POS[medal] || medal
    end

    def brewer_and_beer_line(beer)
      str = beer['brewer'].dup
      str << " (Asst. Brewer: #{beer.dig('beer', 'asst_brewer')})" if beer.dig('beer', 'asst_brewer')
      str << " - #{beer.dig('beer', 'name')}"

      if style = beer.dig('beer', 'style')
        str << " (#{expand_beer_style(style)})"
      end

      str
    end

    def expand_beer_style(style)
      guidelines = LAB.guidelines[comp['guidelines']]

      return style unless guidelines
      return style unless guidelines[style.to_s]

      "#{style} - #{guidelines[style.to_s]}"
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
        html << if medal == 'HM'
                  '<dt>Honourable Mention</dt>'
                elsif medal == '4th'
                  '<dt>Fourth Place</dt>'
                else
                  "<dt>#{medal.titleize} Medals</dt>"
                end

        winners.each do |winner|
          html << "<dd>#{brewer_and_beer_line(winner)}</dd>"
        end
      end

      html.join("\n")
    end
  end
end
