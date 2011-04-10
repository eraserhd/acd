require 'acd/command'

describe ACD::Command do

  describe :command_name do

    it "should return the command-form of the class's name" do
      ACD::Commands::Usage.command_name.should == "usage"
      ACD::Commands::Import.command_name.should == "import"
    end

  end

  describe :summary do

    it "should return the class's SUMMARY, if defined" do
      ACD::Commands::Usage.summary.should == ACD::Commands::Usage::SUMMARY
    end

    it "should return an empty string if SUMMARY is not defined" do
      class ACD::Commands::NoSummaryCommand < ACD::Command; end
      ACD::Commands::NoSummaryCommand.summary.should == ""
      module ACD::Commands; remove_const(:NoSummaryCommand); end
    end

  end

end
