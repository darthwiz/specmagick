module Specmagick
  module CLI
    module TaggedTests

      def using_tags?
        command_options[:tag_given]
      end

      def tag_args
        command_options[:tag].map { |tags| tags.split(',') }.flatten
      end

      def tagged_tests
        Specmagick::Models::Test.with_tags(tag_args)
      end

    end
  end
end
