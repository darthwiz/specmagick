module Specmagick
  module Models
    class TestRun < Sequel::Model
      plugin :timestamps, create: :created_at
      one_to_many :outcomes, class: :TestOutcome
      many_to_many :tests
    end
  end
end
