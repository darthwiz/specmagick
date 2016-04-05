module Specmagick
  module CLI
    class Console < Base

      def execute
        require 'irb'
        ARGV.clear
        %w(Test Tag TestOutcome TestRun).each do |i|
          Kernel.const_set(i, Specmagick::Models.const_get(i))
        end
        IRB.start
      end

    end
  end
end
