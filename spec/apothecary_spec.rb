require 'acd/apothecary'
require 'acd/remedy'
require 'tmpdir'

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

    context 'when loading a remedy' do

      it "should return nil if no remedy exists" do
        ACD::Apothecary.potentize('this_remedy_should_never_exist').should be_nil
      end

      it "should load a remedy and return it if one exists" do
        ENV['ACD_APOTHECARY'] = Dir.tmpdir
        File.open(File.join(Dir.tmpdir,'foo.rb'),'w') do |f|
          f.write <<-EOF
            ACD::Remedy.new do |foo|
              foo.repository = 'foo@example.com'
            end
          EOF
        end
        remedy = ACD::Apothecary.potentize('foo')
        remedy.should_not be_nil
        remedy.should be_kind_of(ACD::Remedy)
        remedy.repository.should == 'foo@example.com'
      end

      it "should set the remedy's name to potentize's argument" do
        ENV['ACD_APOTHECARY'] = Dir.tmpdir
        File.open(File.join(Dir.tmpdir,'foo.rb'),'w') do |f|
          f.write <<-EOF
            ACD::Remedy.new do |foo|
              foo.repository = 'foo@example.com'
            end
          EOF
        end
        remedy = ACD::Apothecary.potentize('foo')
        remedy.name.should == 'foo'
      end

    end

    context 'when using a git URL' do

      it "should create a new remedy with the git URL as a repository" do
        REPO = 'git@github.com:BlueFrogGaming/slime.git'
        remedy = ACD::Apothecary.potentize(REPO)
        remedy.should be_kind_of(ACD::Remedy)
        remedy.repository.should == REPO
      end

      it "should use the git URL's base name as the name" do
        remedy = ACD::Apothecary.potentize('git@github.com:BlueFrogGaming/slime.git')
        remedy.name.should == 'slime'
      end

    end

  end

end
