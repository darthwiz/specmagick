RSpec::Support.require_rspec_core "formatters/base_formatter"
RSpec::Support.require_rspec_core "formatters/base_text_formatter"
RSpec::Support.require_rspec_core "formatters/documentation_formatter"

class Specmagick::Formatter < RSpec::Core::Formatters::DocumentationFormatter
  # Formatters.register self, :message, :dump_summary, :dump_profile, :stop, :close
  # Formatters.register self, :example_group_started, :example_group_finished, :example_passed, :example_pending, :example_failed
  RSpec::Core::Formatters.register self, :example_started, :example_passed, :example_failed, :dump_summary

  def example_started(notification)
    @run    ||= Specmagick::Models::TestRun.create unless dry_run?
    ex        = notification[:example]
    tag_names = ex.metadata.select { |k, v| v == true }.keys
    tags      = tag_names.map { |tag| Specmagick::Models::Tag.find_or_create(name: tag.to_s) }
    @test     = Specmagick::Models::Test.find_or_create(name: test_name(ex)).tap do |test|
      test.position    = ex.id
      test.location    = ex.location
      test.description = ex.full_description
      test.save
    end.tap do |test|
      tags.each { |tag| test.add_tag(tag) rescue nil }
      @run.add_test(test) if @run
    end
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
    super
  end

  private

  def dry_run?
    # Not the best method of identifying a dry run, but for lack of something
    # better, if a test takes less than half a millisecond to run, you don't
    # really need this tool. ;-)
    RSpec.configuration.dry_run
  end

  def test_name(example)
    Specmagick::Util.test_name(example)
  end

  def save_outcome(result)
    return if dry_run?
    Specmagick::Models::TestOutcome.new.tap do |t|
      t.test           = @test
      t.run            = @run
      t.success        = result.status == :passed
      t.execution_time = result.run_time
      t.save
    end
  end

end
