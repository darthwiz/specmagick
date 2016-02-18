module Specmagick
  module CLI
    class Search < Base
      include TaggedTests

      def execute
        detailed? ? detailed : basic
      end

      private

      def detailed?
        command_options[:detailed_given]
      end

      def basic
        tagged_tests_map.keys.each { |loc| puts loc }
      end

      def detailed
        table = TTY::Table.new([ 'File', 'Lines' ], tagged_tests_map.map { |k, v| [ k, v.sort.map { |i| i.to_s }.join(' ') ] })
        puts table.render(:ascii, alignments: [ :left, :right ])
      end

      def tagged_tests_structs
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
