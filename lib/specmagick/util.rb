module Specmagick
  class Util

    def self.test_name(example)
      example.full_description.underscore.gsub(/[^[:alnum:]]/, '_').gsub(/_+/, '_').sub(/_$/, '')
    end

  end
end
