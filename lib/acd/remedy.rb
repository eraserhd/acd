
module ACD

  class Remedy

    class InvalidRemedySpecification <StandardError; end

    def self.last_created
      @@last_created
    end

    def initialize
      yield self if block_given?

      validate

      @@last_created = self
    end

    attr_accessor :repository, :name

    def validate
      raise InvalidRemedySpecification.new('repository was not specified') unless repository
    end

  end

end
