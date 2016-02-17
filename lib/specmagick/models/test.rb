module Specmagick
  module Models
    class Test < Sequel::Model
      many_to_many :tags
      many_to_many :runs, class: :TestRun, right_key: :test_run_id
      one_to_many :outcomes, class: :TestOutcome

      def_dataset_method(:with_tags) do |*args|
        tags = args.flatten.map do |tag|
          case tag
          when Specmagick::Models::Tag
            tag
          when String
            Specmagick::Models::Tag.find(name: tag)
          when Symbol
            Specmagick::Models::Tag.find(name: tag.to_s)
          when Integer
            Specmagick::Models::Tag[tag]
          end
        end
        where(Sequel.&(*tags.map { |tag| { tags: tag } }))
      end

    end
  end
end
