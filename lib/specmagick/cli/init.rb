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
        end
      end

      private

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

    end
  end
end
