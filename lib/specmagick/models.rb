module Specmagick
  module Models
    require 'sequel'
    Sequel.sqlite(Specmagick.conf.db) do |db|
      Specmagick::DB = db
      Sequel::Model.plugin :timestamps
      require 'specmagick/models/test'
      require 'specmagick/models/tag'
      require 'specmagick/models/test_run'
      require 'specmagick/models/test_outcome'
    end
  end
end
