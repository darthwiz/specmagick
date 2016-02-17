module Specmagick
  module CLI
    require 'table_print'
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
        tp counts.map { |k, v| Struct.new(:tag, :count).new(k, v) }
      end

      def list_tags_with_intersections
        int   = Specmagick::Models::Tag.intersections
        list  = lambda { |v| v.map { |i| i.to_s }.sort.join(' ') }
        width = int.values.map { |i| list[i].size }.max
        tp Specmagick::Models::Tag.intersections.map { |k, v| Struct.new(:tag, :intersections).new(k, list[v]) }, :tag, { intersections: { width: width } }
      end

    end
  end
end
