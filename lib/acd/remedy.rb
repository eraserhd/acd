require 'pp'
require 'stringio'

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

    PROPERTIES = [ :repository, :name ]

    attr_accessor *PROPERTIES

    def validate!
      raise InvalidRemedySpecification.new('repository was not specified') unless repository
    end

    def to_s
      s = ""
      s << "ACD::Remedy.new do |r|\n"
      PROPERTIES.each do |property|
        value_stream = StringIO.new("", "w")
        PP.singleline_pp(send(property), value_stream)
        s << "  r.#{property} = #{value_stream.string}\n"
      end
      s << "end\n"
    end

    def save_to_directory(directory)
      raise InvalidRemedySpecification.new('name was not specified') unless name
      File.open(File.join(directory, "#{name}.rb"), "w") {|f| f.write to_s }
    end

  end

end
