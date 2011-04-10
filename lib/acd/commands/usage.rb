
require 'acd/command'

module ACD
  module Commands

    class Usage < Command

      SUMMARY = 'show quick usage'

      def message
        header + command_list + "\n"
      end

      def invoke
        puts message
      end

    private
      def header
        (<<-EOS).split(/\n/).map{|s| s[8..-1]}.join("\n") + "\n"
        acd - Apple Coder utility to manage Xcode projects
        Syntax:
          acd COMMAND [OPTIONS] [ARGS ...]

        Commands:
        EOS
      end

      def command_list
        ACD::Commands.known.map{|c| "  #{c.command_name} - #{c.summary}\n"}.sort.join
      end

    end

  end
end
