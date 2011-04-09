require 'acd/commands/import'

module ACD
  module Commands

    def self.for_args args
      name = args.first.capitalize
      if ACD::Commands.const_defined?(name)
        ACD::Commands.const_get(name)
      else
        nil
      end
    end

    def self.invoke args
      command = args.first
      abort "Unknown command '#{command}'" unless ACD::Commands.const_defined?(command.capitalize)
      ACD::Commands.const_get(command.capitalize).new(args[1..-1]).invoke
    end

  end
end

