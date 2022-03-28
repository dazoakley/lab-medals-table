# frozen_string_literal: true

module LAB
  class DatabaseLoader
    attr_reader :database, :competitions_dir, :guidelines_dir

    def initialize(
      database,
      competitions_dir = File.join(File.dirname(__FILE__), '../../data/'),
      guidelines_dir = File.join(File.dirname(__FILE__), '../../styles/')
    )
      @database = database
      @competitions_dir = competitions_dir
      @guidelines_dir = guidelines_dir
    end

    def load
      load_guidelines
      load_competitions
    end

    def load_competitions
      Dir["#{competitions_dir}*.yaml"].each do |file|
        # puts "file: #{file}"
        data = YAML.load(File.read(file))
        name = data['full_name']
        abbr_name = data['abbr_name'] || name

        # puts "name: #{name}, abbreviated_name: #{abbr_name}"
        competition = Competition.find_or_create(name: name, abbreviated_name: abbr_name,
                                                 exclude_from_points_table: data['exclude_from_points_table'])

        load_edition(competition, data)
      end
    end

    def load_guidelines
      Guideline.find_or_create(name: 'NGWBJ')
      Guideline.find_or_create(name: 'SIBA')
      Guideline.find_or_create(name: 'Local Guidelines')

      # BJCP guidelines
      Dir["#{guidelines_dir}*.json"].each do |file|
        data = JSON.parse(File.read(file))

        guideline = Guideline.find_or_create(name: data['name'])

        load_styles(guideline, data)
      end
    end

    private

    def load_edition(competition, data)
      # puts "year: #{data['year']}, location: #{data['location']}, guidelines: '#{data['guidelines']}'"
      guideline = Guideline.find(name: data['guidelines'])
      location = Location.find_or_create(name: data['location'])

      edition = CompetitionEdition.find_or_create(
        competition_id: competition.id,
        guideline_id: guideline.id,
        location_id: location.id,
        date: data['date']
      )

      load_brewers_and_beers(edition, guideline, data)
    end

    def load_brewers_and_beers(edition, guideline, data)
      data['winners'].each do |winner|
        brewer = Brewer.find_or_create(name: winner['name'])

        Result.rounds.each do |round|
          Result.places.each do |place|
            beers = winner.dig(round, place)
            next unless beers&.any?

            beers.each do |beer_data|
              # puts "GUIDELINE: #{guideline.id} #{guideline.name} - STYLE #{beer_data['style']}"
              beer = find_or_create_beer(brewer, beer_data)
              style = find_or_create_style(beer_data['style'], guideline)

              Result.find_or_create(
                competition_edition_id: edition.id,
                beer_id: beer.id,
                style_id: style.id,
                round: round,
                place: place
              )
            end
          end
        end
      end
    end

    def find_or_create_beer(brewer, data)
      asst_brewer_id = Brewer.find_or_create(name: data['asst_brewer']).id if data['asst_brewer']

      Beer.find_or_create(
        name: data['name'],
        brewer_id: brewer.id,
        assistant_brewer_id: asst_brewer_id
      )
    end

    def find_or_create_style(number, guideline)
      style = Style.find(number: number, guideline_id: guideline.id)
      return style unless style.nil?

      # puts "UNKNOWN STYLE: #{number} (#{guideline.name})"
      number = 'NONE' if number.nil?
      Style.find_or_create(number: number, guideline_id: guideline.id)
    end

    def load_styles(guideline, data)
      export = {}

      data['children']&.each do |klass|
        klass['children'].each do |style|
          number = style['number']

          if style['children']
            style['children'].each do |subcat|
              export["#{number}#{subcat['letter']}"] = subcat['name']
            end
          else
            export[number] = style['name']
          end
        end
      end

      export.each do |number, name|
        Style.find_or_create(number: number, name: name, guideline_id: guideline.id)
      end
    end
  end
end
