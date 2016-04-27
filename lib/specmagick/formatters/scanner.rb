require 'specmagick/formatters/base'

class Specmagick::Formatters::Scanner
  include Specmagick::Formatters::Base
  RSpec::Core::Formatters.register self, :example_started, :dump_summary

  def initialize(*args)
  end

  def example_started(notification)
    register_test(notification.example)
  end

  def dump_summary(notification)
    test_count = Specmagick::Models::Test.count
    tag_count  = Specmagick::Models::Tag.count
    purged     = purge_renamed_tests
    puts "#{test_count} tests scanned, #{tag_count} tags found."
    puts "#{purged} renamed tests purged." if purged > 0
  end

end
