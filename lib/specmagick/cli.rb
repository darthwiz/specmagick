module Specmagick
  module CLI
    require 'tty-table'
    require 'tty-screen'
    require 'specmagick/cli/base'
    require 'specmagick/cli/init'
    require 'specmagick/cli/tagged_tests'
    require 'specmagick/cli/run'
    require 'specmagick/cli/search'
    require 'specmagick/cli/tags'
    require 'specmagick/cli/vcr'
    require 'specmagick/cli/migrate'
    require 'specmagick/cli/console'

    def self.action=(action)
      @action = action
    end

    def self.action
      @action
    end

  end
end
