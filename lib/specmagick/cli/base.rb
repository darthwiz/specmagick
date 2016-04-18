module Specmagick
  module CLI
    class Base < Escort::ActionCommand::Base

      def initialize(*args)
        configure_db
        super
      end

      private

      def schema_dir
        Pathname.new(File.dirname(__FILE__)).join('../../specmagick/db/schema')
      end

      def migrations_dir
        Pathname.new(File.dirname(__FILE__)).join('../../specmagick/db/migrations')
      end

      def db_file
        data_dir.join('db.sqlite')
      end

      def db_exists?
        File.exists?(db_file)
      end

      def data_dir
        Pathname.new(Dir.pwd).join('.specmagick')
      end

      def data_dir_exists?
        Dir.exists?(data_dir)
      end

      def configure_db
        Specmagick.configure do |conf|
          conf.db = db_file.to_s
        end
      end

      def forced?
        command_options[:force_given]
      end

      def spec_dir
        Specmagick::Helpers.spec_dir
      end

      def vcr_dir
        Specmagick::Helpers.vcr_dir
      end

    end
  end
end
