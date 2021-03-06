module Specmagick
  module CLI
    require 'rspec/core'
    class Run < Base
      include TaggedTests

      def execute
        Specmagick::CLI.action = self
        ENV['SKIP_VCR'] = 'true' if live?
        if listing_latest?
          list_latest
        elsif listing_named?
          list_named
        elsif setting_name?
          set_name
        elsif rerunning_failed?
          rerun_failed
        else
          RSpec::Core::Runner.run(computed_args)
        end
      end

      private

      def latest_scope
        Specmagick::Models::TestRun.order(Sequel.desc(:created_at)).limit(10)
      end

      def named_scope
        latest_scope.where(Sequel.~(name: nil))
      end

      def list_latest
        list(latest_scope)
      end

      def list_named
        list(named_scope)
      end

      def list(scope)
        tf    = "%Y-%m-%d %H:%M"
        data  = scope.map { |r| [ r.id, r.created_at.strftime(tf), r.name, r.outcomes.count, r.failures.count ] }.reverse
        table = TTY::Table.new([ 'id', 'time', 'name', 'tests', 'fails' ], data)
        puts table.render(:ascii, alignments: [ :right, :right, :left, :right, :right ])
      end

      def set_name
        (id, name) = command_options[:set_name].split(':', 2)
        run = id == 'last' ? Specmagick::Models::TestRun.last : Specmagick::Models::TestRun.with_pk!(id)
        run.name = name
        run.save
      end

      def rerun_failed
        tag  = command_options[:rerun_failed]
        if tag.to_i > 0
          run = Specmagick::Models::TestRun.with_pk!(tag)
        elsif tag == 'last'
          run = Specmagick::Models::TestRun.last
        else
          run = Specmagick::Models::TestRun.where(name: tag).last
        end
        failed_tests = run.failures.map(&:test)
        rebuild_cassettes(failed_tests) if rebuilding_vcr?
        args = computed_args.tap(&:pop) + failed_tests.map(&:location)
        RSpec::Core::Runner.run(args)
      end

      def rebuild_cassettes(tests)
        tests.each do |test|
          path = Pathname.new(vcr_dir).join("#{test.name}.yml")
          FileUtils.rm(path) if File.exists?(path)
        end
      end

      def live?
        command_options[:live_given]
      end

      def rerunning_failed?
        command_options[:rerun_failed_given]
      end

      def listing_latest?
        command_options[:list_latest_given]
      end

      def listing_named?
        command_options[:list_named_given]
      end

      def setting_name?
        command_options[:set_name_given]
      end

      def rebuilding_vcr?
        command_options[:rebuild_vcr_given]
      end

      def computed_args
        args  = [ '-f', 'Specmagick::Formatters::Documentation' ]
        args += [ '--dry-run' ] if command_options[:dry_run]
        args += tagged_tests.map { |t| t.location } if using_tags?
        args += ((arguments.empty? && !using_tags?) ? %w(spec) : arguments)
        args
      end

    end
  end
end
