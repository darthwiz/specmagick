module Specmagick
  module CLI
    class Init < Base

      def execute
        if db_exists? && !forced?
          warn_db_exists
        else
          ensure_data_dir
          delete_db_if_present
          migrate_initial_schema
          align_migration_table
        end
        scan_tests if scan?
      end

      private

      def configure_db
        super rescue nil
      end

      def scan?
        command_options[:scan]
      end

      def scan_tests
        require 'rspec/core'
        RSpec::Core::Runner.run([ '-f', 'Specmagick::Formatters::Scanner', '--dry-run', spec_dir.to_s ])
      end

      def migrate_initial_schema
        Sequel.extension :migration
        Sequel::Migrator.run(Specmagick::DB, schema_dir)
      end

      def warn_db_exists
        puts "Database already exists: #{db_file}"
        puts "Use --force option to create a new database."
      end

      def delete_db_if_present
        FileUtils.rm(db_file) if File.exists?(db_file)
      end

      def ensure_data_dir
        Dir.mkdir(data_dir) unless data_dir_exists?
      end

      def align_migration_table
        Dir.glob(Pathname.new(migrations_dir).join('*')).reject { |i| i =~ /_schema\.rb$/ }.each do |fn|
          DB[:schema_migrations].insert(filename: File.basename(fn))
        end
      end

    end
  end
end
