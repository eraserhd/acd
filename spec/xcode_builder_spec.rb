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
        system 'git init >/dev/null 2>&1'
        example.run
      end
      @cage.dispose
    end

    context 'when initializing the project' do
      
      subject { ACD::XcodeBuilder.new(ACD::XcodeProject.new) }
      
      it "should create the .xcodeproj directory" do
        subject.build 
        File.directory?('Foo.xcodeproj').should be_true
      end

      it "should create the *.xcodeproj/project.pbxproj file" do
        subject.build 
        File.exist?('Foo.xcodeproj/project.pbxproj').should be_true
      end

      it "should add the project.pbxproj to git" do
        subject.build
        `git status --short Foo.xcodeproj/project.pbxproj`.should match(/^A/)
      end

    end

  end

end
