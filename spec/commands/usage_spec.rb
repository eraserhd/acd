require 'acd/commands'
require 'acd/commands/usage'

describe ACD::Commands::Usage do

  describe :message do
    
    it "should contain a Syntax: line" do
      ACD::Commands::Usage.new([]).message.should match(/Syntax:/)
    end

    it "should contain a line for each available command" do
      msg = ACD::Commands::Usage.new([]).message
      msg.should include "import"
      msg.should include "usage"
    end

    it "should contain summaries for each available command" do
      msg = ACD::Commands::Usage.new([]).message
      msg.should include ACD::Commands::Usage::SUMMARY
      msg.should include ACD::Commands::Import::SUMMARY
    end

    it "should contain the commands in sorted order" do
      msg = ACD::Commands::Usage.new([]).message
      msg.should match /#{ACD::Commands::known.map(&:command_name).sort.join(".*")}/m
    end

  end

end
