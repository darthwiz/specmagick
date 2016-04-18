module Specmagick
  module Helpers

    def self.included(base)
      RSpec.configure do |config|
        # FIXME must figure out why this doesn't work
        # config.before :each do |example|
        #   @example = example
        # end
      end
    end

    def self.test_name(example)
      example.full_description.underscore.gsub(/[^[:alnum:]]/, '_').gsub(/_+/, '_').sub(/_$/, '')
    end

    def self.spec_dir
      Pathname.new(Dir.pwd).join('spec')
    end

    def self.vcr_dir
      spec_dir.join('fixtures/vcr')
    end

    def self.using_vcr?
      !ENV['SKIP_VCR']
    end

    def vcr_dir
      Specmagick::Helpers.vcr_dir
    end

    def using_vcr?
      Specmagick::Helpers.using_vcr?
    end

    def vcr_cassette_name
      Specmagick::Helpers.test_name(@example)
    end

    def vcr_cassette_path
      vcr_dir.join("#{vcr_cassette_name}.yml")
    end

    def vcr_cassette_exists?
      File.exists?(vcr_cassette_path)
    end

    def wait_for_elasticsearch_indexing
      sleep 1 if !using_vcr? || !vcr_cassette_exists?
    end

  end
end
