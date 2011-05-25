require 'acd/remedy'

describe ACD::Remedy do
    
  let :remedy do
    ACD::Remedy.new do |r|
      r.name = 'foo'
      r.repository = 'foo'
    end
  end

  let :remedy_without_name do
    ACD::Remedy.new do |r|
      r.repository = 'foo'
    end
  end

  describe '::new' do

    it "should keep a reference to the last created" do
      r = ACD::Remedy.new do |r|
        r.repository = 'foo'
      end
      ACD::Remedy.last_created.should be(r)
    end

  end

  describe '#validate!' do
    it "should raise if the repository was not set" do
      lambda { ACD::Remedy.new.validate! }.should raise_error(ACD::Remedy::InvalidRemedySpecification)
    end
  end

  it "should allow setting the repository" do
    remedy.repository.should == 'foo'
  end

  describe '#xcode_project' do

    before(:each) do
      @remedy = ACD::Remedy.new do |r|
        r.repository = 'foo'
      end
    end
    
    it "should accept a block taking an argument" do
      @remedy.xcode_project {|p|}
    end

    it "should return nil by default" do
      @remedy.xcode_project.should be_nil
    end

    it "should not create an xcode project if called without a block" do
      @remedy.xcode_project.should be_nil
      @remedy.xcode_project.should be_nil
    end

    it "should yield an XcodeProject to the block given" do
      block_was_run = false
      @remedy.xcode_project do |p|
        p.should be_kind_of(ACD::XcodeProject)
        block_was_run = true
      end
      block_was_run.should be_true
    end
    
    it "should return the XcodeProject that was yielded" do
      yielded_value = nil
      returned_value = @remedy.xcode_project do |p|
        yielded_value = p
      end
      returned_value.should be(yielded_value)
    end

    it "should return the XcodeProject that was yielded on subsequent invocations without a block" do
      yielded_value = nil
      @remedy.xcode_project do |p|
        yielded_value = p
      end
      @remedy.xcode_project.should be(yielded_value)
    end

  end

end
