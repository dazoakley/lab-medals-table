# frozen_string_literal: true

require 'yaml'
require 'pry'
require 'awesome_print'
require 'json'
require 'sequel'

require 'lab/data_loader'
require 'lab/roll_of_honour_builder'
require 'lab/competition_roll_of_honour_builder'
require 'lab/csv_export_builder'
require 'lab/points_over_time_builder'

module LAB
  autoload :Beer, 'lab/beer'
  autoload :Brewer, 'lab/brewer'
  autoload :Competition, 'lab/competition'
  autoload :CompetitionEdition, 'lab/competition_edition'
  autoload :DatabaseLoader, 'lab/database_loader'
  autoload :Db, 'lab/db'
  autoload :Guideline, 'lab/guideline'
  autoload :Location, 'lab/location'
  autoload :Result, 'lab/result'
  autoload :Sorter, 'lab/sorter'
  autoload :Style, 'lab/style'
  autoload :TableBuilder, 'lab/table_builder'

  # Scores awarded for each medal
  SCORES = {
    'flight' => {
      'gold' => 10,
      'silver' => 5,
      'bronze' => 2.5
    },
    'bos' => {
      'gold' => 20,
      'silver' => 10,
      'bronze' => 5
    }
  }.freeze

  class << self
    def sections
      %w[flight bos]
    end

    def medals
      %w[gold silver bronze]
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
