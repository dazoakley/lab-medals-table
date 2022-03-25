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
    end

    def load_guidelines
      Dir["#{guidelines_dir}*.json"].each do |file|
        data = JSON.parse(File.read(file))

        guideline = Guideline.find_or_create(name: data['name'])

        database.transaction do
          guideline.save
        end

        load_styles(guideline, data)
      end
    end

    private

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

      database.transaction do
        export.each do |number, name|
          style = Style.find_or_create(number: number, name: name, guideline_id: guideline.id)
          style.save
        end
      end
    end
  end
end
