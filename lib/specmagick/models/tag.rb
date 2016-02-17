module Specmagick
  module Models
    class Tag < Sequel::Model
      many_to_many :tests

      def_dataset_method(:test_counts) do
        eager_graph(:tests).group(:tags__id).select { [ :tags__name, count(:tags__id).as(:count) ] }.order(Sequel.desc(:count))
      end

      def self.counts
        Specmagick::Models::Tag.test_counts.map { |i| [ i[:name].to_sym, i[:count] ] }.to_h
      end

      def self.intersections
        tests = {}
        db[:tags_tests].each do |tt|
          tests[tt[:test_id]] ||= []
          tests[tt[:test_id]] << tt[:tag_id]
        end
        tests.each_pair { |k, v| v.uniq! }
        tags = {}
        tests.values.each do |tag_ids|
          tag_ids.each do |tag_id|
            tags[tag_id] ||= []
            tags[tag_id] += tag_ids
          end
        end
        tag_map = Tag.inject({}) { |map, i| map.tap { |map| map[i.id] = i.name.to_sym } }
        tags.map { |k, v| [ tag_map[k], (v.uniq - [ k ]).map { |i| tag_map[i] } ] }.sort_by { |i| i[0] }.to_h
      end

    end
  end
end
