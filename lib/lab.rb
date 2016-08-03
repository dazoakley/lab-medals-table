require 'yaml'
require 'pry'
require 'awesome_print'

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
  end
end
