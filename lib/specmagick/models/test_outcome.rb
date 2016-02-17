module Specmagick
  module Models
    class TestOutcome < Sequel::Model
      many_to_one :test
      many_to_one :run, class: :'Specmagick::Models::TestRun', key: :run_id
    end
  end
end
