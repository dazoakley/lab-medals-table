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

namespace :db do
  desc 'Run database migrations'
  task :migrate do
    LAB::Db.migrate
  end

  desc 'Rollback database migrations'
  task :rollback do
    LAB::Db.rollback
  end
end
