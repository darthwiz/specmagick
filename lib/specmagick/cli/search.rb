module Specmagick
  module CLI
    require 'table_print'
    class Search < Base
      include TaggedTests

      def execute
        if command_options[:detailed_given]
          detailed
        else
          basic
        end
      end

      private

      def basic
        tagged_tests_map.keys.each { |loc| puts loc }
      end

      def detailed
        loc_width = tagged_tests_structs.map { |i| i.location.length }.max
        ln_width  = tagged_tests_structs.map { |i| i.lines.length }.max
        tp tagged_tests_structs, { location: { width: loc_width } }, { lines: { width: ln_width } }
      end

      def tagged_tests_structs
        tagged_tests_map.map { |k, v| Struct.new(:location, :lines).new(k, v.map { |i| i.to_s }.join(' ')) }
      end

      def tagged_tests_map
        {}.tap do |h|
          tagged_tests.each do |t|
            filename, line = t.location.split(/:([0-9]+$)/)
            h[filename] ||= []
            h[filename] << line.to_i
          end
        end.map { |k, v| [ k, v.sort ] }.to_h
      end

    end
  end
end
