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

  describe '#to_s' do

    it "should start with 'ACD::Remedy.new do |r|'" do
      remedy.to_s.split(/\n/).first.should match(/^\s*ACD::Remedy\.new do \|r\|/)
    end

    it "should end with 'end'" do
      remedy.to_s.split(/\n/).last.should match(/^end\s*$/)
    end

    it "should have all properties except name" do
      ACD::Remedy::PROPERTIES.each do |property|
        next if property == :name
        remedy.to_s.should match(/^  r\.#{property} = /)
      end
      remedy.to_s.should_not match(/^r\.name =/)
    end

    it "should be valid ruby code and load" do
      eval remedy.to_s
    end

    it "should preserve property values (except name)" do
      r = eval remedy.to_s
      r.repository.should == remedy.repository
    end

  end

  describe '#save_to_directory' do

    it "should raise if the remedy has no name" do
      lambda {remedy_without_name.save_to_directory(Dir.tmpdir)}.should raise_error
    end

    it "should write #to_s to a file in the specified directory" do
      tmpdir = Dir.tmpdir 
      File.delete(File.join(tmpdir, 'foo.rb'))
      remedy.save_to_directory(tmpdir)
      File.should exist(File.join(tmpdir, 'foo.rb'))
    end
     
  end
  
end
