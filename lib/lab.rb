require 'yaml'
require 'pry'
require 'awesome_print'
require 'json'

require 'lab/data_loader'
require 'lab/sorter'
require 'lab/html_table_builder'
require 'lab/roll_of_honour_builder'
require 'lab/competition_roll_of_honour_builder'

module LAB
  # Scores awarded for each medal
  SCORES = {
    'flight' => {
      'gold'   => 10,
      'silver' => 5,
      'bronze' => 2.5
    },
    'bos'    => {
      'gold'   => 20,
      'silver' => 10,
      'bronze' => 5
    }
  }.freeze

  class << self
    def sections
      %w(flight bos)
    end

    def medals
      %w(gold silver bronze)
    end

    def guidelines
      @guidelines ||= {
        'BJCP 2008' => load_style_file('bjcp-2008.json'),
        'BJCP 2015' => load_style_file('bjcp-2015.json')
      }
    end

    private

    def load_style_file(file)
      path = File.join([File.dirname(__FILE__), '..', 'styles', file])
      raw  = JSON.parse(File.read(path))
      data = {}

      raw['children'].each do |klass|
        klass['children'].each do |style|
          number = style['number']

          if style['children']
            style['children'].each do |subcat|
              data["#{number}#{subcat['letter']}"] = subcat['name']
            end
          else
            data[number] = style['name']
          end
        end
      end

      data
    end
  end
end
