# frozen_string_literal: true

require 'yaml'
require 'pry'
require 'awesome_print'
require 'json'
require 'sequel'

require 'lab/points_over_time_builder'

module LAB
  autoload :Beer, 'lab/beer'
  autoload :Brewer, 'lab/brewer'
  autoload :Competition, 'lab/competition'
  autoload :CompetitionEdition, 'lab/competition_edition'
  autoload :CsvExportBuilder, 'lab/csv_export_builder'
  autoload :DatabaseLoader, 'lab/database_loader'
  autoload :Db, 'lab/db'
  autoload :Guideline, 'lab/guideline'
  autoload :Location, 'lab/location'
  autoload :Result, 'lab/result'
  autoload :RollOfHonourBuilder, 'lab/roll_of_honour_builder'
  autoload :Sorter, 'lab/sorter'
  autoload :Style, 'lab/style'
  autoload :TableBuilder, 'lab/table_builder'
end
