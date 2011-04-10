
Dir.new(File.join(File.dirname(__FILE__), 'commands')).select{|f| f=~/\.rb$/}.each do |cmd|
  require "acd/commands/#{cmd}"
end

module ACD
  module Commands

    def self.known
      ACD::Commands.constants.map{|c| ACD::Commands.const_get(c)}.select{|c| c.ancestors.include?(ACD::Command)}
    end

    def self.for_args args
      return ACD::Commands::Usage if args.empty?
      name = args.first.capitalize
      if ACD::Commands.const_defined?(name)
        ACD::Commands.const_get(name)
      else
        ACD::Commands::Usage
      end
    end

    def self.invoke args
      klass = for_args(args)
      klass.new(args[1..-1]).invoke
    end

  end
end

