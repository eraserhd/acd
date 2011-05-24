require 'acd/apothecary'

describe ACD::Apothecary do

  describe '::directory' do

    it "should return the directory relative to the apothecary.rb file" do
      ENV.delete('ACD_APOTHECARY')
      ACD::Apothecary::directory.should == File.join(Dir.getwd,'lib/acd/apothecary')
    end

    it "should return the directory in $ACD_APOTHECARY when set" do
      ENV['ACD_APOTHECARY'] = '/tmp/apothecary'
      ACD::Apothecary::directory.should == '/tmp/apothecary'
    end
    
  end

end
