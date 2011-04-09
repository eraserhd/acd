
require 'acd/command'

module ACD
  module Commands

    class Usage < Command

      def invoke
        puts "acd - Apple Coder utility to manage Xcode projects"
        puts "Syntax:"
        puts "  acd COMMAND [OPTIONS] [ARGS ...]"
        puts ""
      end

    end

  end
end
