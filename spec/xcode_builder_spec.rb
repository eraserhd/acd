require 'acd/cage'
require 'acd/xcode_project'
require 'acd/xcode_builder'

describe ACD::XcodeBuilder do

  describe '#build' do

    around(:each) do |example|
      @cage = ACD::Cage.new
      @cage.execute do
        Dir.mkdir('Foo')
        Dir.chdir('Foo')
      end
      example.run
      @cage.dispose
    end

    context 'when initializing the project' do
      
      it "should create the .xcodeproj directory" do
        @cage.execute do
          File.directory?('Foo.xcodeproj').should be_false
          ACD::XcodeBuilder.new(ACD::XcodeProject.new).build 
          File.directory?('Foo.xcodeproj').should be_true
        end
      end
    end

  end

end
