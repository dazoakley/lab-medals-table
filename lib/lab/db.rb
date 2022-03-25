# frozen_string_literal: true

require 'sequel'

Sequel.extension :migration

module LAB
  class Db
    class << self
      def connect
        @connect ||= Sequel.connect(ENV.fetch('DATABASE_URL', database_dsn))
      end

      def disconnect
        @connect&.disconnect
        @connect = nil
      end

      def migrate
        Sequel::Migrator.apply(connect, migrations_dir)
      end

      def rollback
        version = (row = connect[:schema_info].first) ? row[:version] : nil
        Sequel::Migrator.apply(connect, migrations_dir, version - 1)
      end

      def ready?
        connect.execute('SELECT 1')
        true
      rescue Sequel::Error
        false
      end

      def drop
        FileUtils.rm_rf(database_file)
      end

      def migrations_dir
        File.join(File.dirname(__FILE__), '../../db/migrations')
      end

      def database_dsn
        "sqlite://#{database_file}"
      end

      def database_file
        'db/lab.db'
      end
    end
  end
end
