module Specmagick
  module CLI
    class Tags < Base

      def execute
        if command_options[:intersections]
          list_tags_with_intersections
        else
          list_tags_with_count
        end
      end

      def list_tags_with_count
        counts = Specmagick::Models::Tag.counts
        table  = TTY::Table.new([ 'Tag', 'Count' ], counts.to_a)
        puts table.render(:ascii, alignments: [ :left, :right ])
      end

      def list_tags_with_intersections
        list  = lambda { |v| v.map { |i| i.to_s }.sort.join(' ') }
        data  = Specmagick::Models::Tag.intersections.map { |k, v| [ k, list[v] ] }
        table = TTY::Table.new([ 'Tag', 'Intersections' ], data)
        w1    = data.map { |i| i[0].length }.max
        w2    = TTY::Screen.new.width - w1 - 3
        puts table.render(:ascii, multiline: true, column_widths: [ w1, w2 ])
      end

    end
  end
end
