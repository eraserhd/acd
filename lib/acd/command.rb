
module ACD
  class Command
    attr_reader :args

    def initialize args
      @args = args
    end

    def invoke; end

  end
end
