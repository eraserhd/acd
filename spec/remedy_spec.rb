require 'acd/remedy'

describe ACD::Remedy do

  describe '::new' do

    it "should keep a reference to the last created" do
      r = ACD::Remedy.new do |r|
        r.repository = 'foo'
      end
      ACD::Remedy.last_created.should be(r)
    end

    it "should raise if the repository was not set" do
      lambda { ACD::Remedy.new }.should raise_error(ACD::Remedy::InvalidRemedySpecification)
    end

  end

  it "should allow setting the repository" do
    r = ACD::Remedy.new do |r|
      r.repository = 'foo'
    end
    r.repository.should == 'foo'
  end
  
end
