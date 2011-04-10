
module ACD
  class Command
    attr_reader :args

    def self.command_name
      self.name.downcase.gsub(/^.*:/, "")
    end

    SUMMARY = ''
    def self.summary
      const_get :SUMMARY
    end

    def initialize args
      @args = args
    end

    def invoke; end

  end
end
