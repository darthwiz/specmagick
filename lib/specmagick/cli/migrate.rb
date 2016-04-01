module Specmagick
  module CLI
    class Migrate < Base

      def execute
        migrate_to_current
      end

      private

      def migrate_to_current
        Sequel.extension :migration
        Sequel::Migrator.run(Specmagick::DB, migrations_dir)
      end

    end
  end
end
