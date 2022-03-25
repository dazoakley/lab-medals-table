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

DB = LAB::Db.connect

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
  task load: :migrate do
    LAB::DatabaseLoader.new(DB).load
  end

  desc 'Drop the database'
  task :drop do
    LAB::Db.drop
  end
end
