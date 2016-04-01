module Specmagick
  module Models
    class TestRun < Sequel::Model
      plugin :timestamps, create: :created_at
      one_to_many :outcomes, class: :'Specmagick::Models::TestOutcome', key: :run_id
      one_to_many :successes, class: :'Specmagick::Models::TestOutcome', key: :run_id do |outc|
        outc.where { success =~ true }
      end
      one_to_many :failures, class: :'Specmagick::Models::TestOutcome', key: :run_id do |outc|
        outc.where { success =~ false }
      end
      many_to_many :tests
    end
  end
end
