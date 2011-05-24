require 'acd/apothecary'

describe ACD::Apothecary do

  describe '::directory' do

    it "should return the directory relative to the apothecary.rb file" do
      ENV.delete('ACD_APOTHECARY')
      ACD::Apothecary.directory.should == File.join(Dir.getwd,'lib/acd/apothecary')
    end

    it "should return the directory in $ACD_APOTHECARY when set" do
      ENV['ACD_APOTHECARY'] = '/tmp/apothecary'
      ACD::Apothecary.directory.should == '/tmp/apothecary'
    end
    
  end

  describe '::potentize' do

    it "should return nil if no formula exists" do
      ACD::Apothecary.potentize('this_formula_should_never_exist').should be_nil
    end

  end

end
