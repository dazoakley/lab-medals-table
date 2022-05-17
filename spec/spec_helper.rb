# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  load_profile 'test_frameworks'
  merge_timeout 3600
  coverage_dir 'artifacts/coverage'
end

require_relative '../lib/lab'

ENV['DATABASE_URL'] = 'sqlite:/'

DB = LAB::Db.connect
LAB::Db.migrate

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed

  config.around(:each) do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) do
      example.run
    end
  end
end

def stub_database
  competitions_dir = File.join(File.dirname(__FILE__), 'fixtures/')
  guidelines_dir = File.join(File.dirname(__FILE__), '../styles/')

  LAB::DatabaseLoader.new(DB, competitions_dir, guidelines_dir).load
end
