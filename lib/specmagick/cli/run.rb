module Specmagick
  module CLI
    require 'rspec/core'
    class Run < Base
      include TaggedTests

      def execute
        RSpec::Core::Runner.run(computed_args)
      end

      def computed_args
        args  = [ '-f', 'Specmagick::Formatter' ]
        args += [ '--dry-run' ] if command_options[:dry_run]
        args += tagged_tests.map { |t| t.location } if using_tags?
        args += ((arguments.empty? && !using_tags?) ? %w(spec) : arguments)
        args
      end

    end
  end
end
