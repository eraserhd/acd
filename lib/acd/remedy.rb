require 'pp'
require 'stringio'
require 'acd/xcode_project'

module ACD

  class Remedy

    class InvalidRemedySpecification <StandardError; end

    def self.last_created
      @@last_created
    end

    def initialize
      yield self if block_given?
      @@last_created = self
    end

    attr_accessor :repository, :name

    def xcode_project &block
      if block_given?
        @xcode_project = XcodeProject.new
        block.call(@xcode_project)
      end
      @xcode_project
    end

    def validate!
      raise InvalidRemedySpecification.new('repository was not specified') unless repository
    end

  end

end
