require 'acd/commands'

describe ACD::Commands do

  describe :for_args do
    
    it "should return the class for the specified command" do
      ACD::Commands::for_args(["import", "foo"]).should be(ACD::Commands::Import);
    end

    it "should return the usage class if no command specified" do
      ACD::Commands::for_args([]).should be(ACD::Commands::Usage)
    end

  end

  describe :known do
    
    it "should return an array" do
      ACD::Commands::known.should be_kind_of(Array)
    end

    it "should contain the 'usage' command" do
      ACD::Commands::known.should include(ACD::Commands::Usage)
    end

    it "should contain the 'import' command" do
      ACD::Commands::known.should include(ACD::Commands::Import)
    end

  end

end
