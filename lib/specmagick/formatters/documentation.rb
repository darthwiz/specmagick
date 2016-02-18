require 'specmagick/formatters/base'

class Specmagick::Formatters::Documentation < RSpec::Core::Formatters::DocumentationFormatter
  include Specmagick::Formatters::Base
  # Formatters.register self, :message, :dump_summary, :dump_profile, :stop, :close
  # Formatters.register self, :example_group_started, :example_group_finished, :example_passed, :example_pending, :example_failed
  RSpec::Core::Formatters.register self, :example_started, :example_passed, :example_failed, :dump_summary

  def example_started(notification)
    register_test(notification.example)
  end

  def example_passed(notification)
    super.tap do
      save_outcome(notification.example.execution_result)
    end
  end

  def example_failed(notification)
    super.tap do
      save_outcome(notification.example.execution_result)
    end
  end

  def dump_summary(notification)
    super.tap do
      unless @errors.empty?
        puts "\nCould not save the outcome for the following tests, probably because of duplicated descriptions:"
        @errors.map { |i| i.location }.sort.each do |test|
          puts test
        end
      end
    end
  end

end
