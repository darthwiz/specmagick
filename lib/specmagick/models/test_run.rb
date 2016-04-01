module Specmagick
  module Models
    class TestRun < Sequel::Model
      plugin :timestamps, create: :created_at
      one_to_many :outcomes, class: :'Specmagick::Models::TestOutcome', key: :run_id
      many_to_many :tests
    end
  end
end
