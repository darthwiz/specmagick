require "specmagick/version"

module Specmagick
  require 'specmagick/helpers'
  require 'specmagick/configuration'

  def self.configure
    yield conf
    require 'specmagick/models'
  end

  def self.conf
    @conf ||= Configuration.new
  end

end
