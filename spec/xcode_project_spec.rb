require 'acd/xcode_project'

describe ACD::XcodeProject do

  subject { ACD::XcodeProject.new }

  describe '#import_target' do

    it "should allow setting the target with properties" do
      lambda {subject.import_target 'Foo', :from => '/tmp'}.should_not raise_error
    end
    
  end

end
