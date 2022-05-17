#!/usr/bin/env rake
# frozen_string_literal: true

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
require 'lab'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  task default: :spec
rescue LoadError
end

db = LAB::Db.connect

namespace :db do
  desc 'Run database migrations'
  task :migrate do
    LAB::Db.migrate
  end

  desc 'Rollback database migrations'
  task :rollback do
    LAB::Db.rollback
  end

  desc 'Load the database with data'
  task load: %i[drop migrate] do
    LAB::DatabaseLoader.new(db).load
  end

  desc 'Drop the database'
  task :drop do
    LAB::Db.drop
    LAB::Db.disconnect
    db = LAB::Db.connect
  end
end

namespace :build do
  desc 'Build the results table'
  task :table do
    puts LAB::TableBuilder.build
  end

  desc 'Build the roll of honour'
  task :roll do
    puts LAB::RollOfHonourBuilder.build
  end

  desc 'Build the CSV export'
  task :csv do
    puts LAB::CsvExportBuilder.build
  end
end
