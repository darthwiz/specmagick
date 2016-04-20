RSpec::Support.require_rspec_core "formatters/base_formatter"
RSpec::Support.require_rspec_core "formatters/base_text_formatter"
RSpec::Support.require_rspec_core "formatters/documentation_formatter"

module Specmagick
  module Formatters
    module Base

      private

      def dry_run?
        # Not the best method of identifying a dry run, but for lack of something
        # better, if a test takes less than half a millisecond to run, you don't
        # really need this tool. ;-)
        RSpec.configuration.dry_run
      end

      def test_name(example)
        Specmagick::Helpers.test_name(example)
      end

      def register_test(example)
        @errors ||= []
        @run    ||= Specmagick::Models::TestRun.create unless dry_run?
        tag_names = example.metadata.select { |k, v| v == true }.keys
        tags      = tag_names.map { |tag| Specmagick::Models::Tag.find_or_create(name: tag.to_s) }
        @test     = Specmagick::Models::Test.find_or_create(name: test_name(example)).tap do |test|
          test.position    = example.id rescue nil
          test.location    = example.location
          test.description = example.full_description
          test.save
        end.tap do |test|
          tags.each { |tag| test.add_tag(tag) rescue nil }
          @run.add_test(test) if @run
        end
      end

      def save_outcome(result)
        return if dry_run?
        begin
          Specmagick::Models::TestOutcome.new.tap do |t|
            t.test           = @test
            t.run            = @run
            t.success        = result.status == :passed
            t.execution_time = result.run_time
            t.save
          end
        rescue
          @errors << @test
        end
      end

      def smg_action
        Specmagick::CLI.action
      end

      def vcr_dir
        Specmagick::Helpers.vcr_dir
      end

      def vcr_cassette_name(test)
        Specmagick::Helpers.test_name(test)
      end

      def vcr_cassette_path(test)
        vcr_dir.join("#{vcr_cassette_name(test)}.yml")
      end

      def vcr_cassette_exists?(test)
        File.exists?(vcr_cassette_path(test))
      end

      def rebuilding_vcr?
        smg_action.send(:rebuilding_vcr?) rescue false
      end

      def remove_vcr_cassette_if_needed(test)
        FileUtils.rm(vcr_cassette_path(test)) if rebuilding_vcr? && vcr_cassette_exists?(test)
      end

    end
  end
end
