require 'acd/commands/import'

module ACD
  module Commands

    def self.invoke args
      command = args.first
      abort "Unknown command '#{command}'" unless ACD::Commands.const_defined?(command.capitalize)
      ACD::Commands.const_get(command.capitalize).new(args[1..-1]).invoke
    end

  end
end

