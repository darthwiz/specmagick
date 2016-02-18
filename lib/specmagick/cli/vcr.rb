module Specmagick
  module CLI
    class VCR < Base

      def execute
        if check?
          filenames = cassettes_without_tests.map { |i| vcr_dir.join("#{i}.yml").relative_path_from(Pathname.new(Dir.pwd)) }
          filenames.each { |i| puts i }
        end
      end

      private

      def check?
        command_options[:check_given]
      end

      def cassette_names
        Dir.glob(vcr_dir.join('*.yml')).map { |i| File.basename(i).sub(/.yml$/, '') }
      end

      def test_names
        Specmagick::Models::Test.select(:name).map { |i| i.name }
      end

      def cassettes_without_tests
        cassette_names - test_names
      end

      def tests_without_cassettes
        Specmagick::Models::Test.where(name: test_names - cassette_names)
      end

    end
  end
end
