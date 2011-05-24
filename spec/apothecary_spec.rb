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

    it "should return nil if no formula exists" do
      ACD::Apothecary.potentize('this_formula_should_never_exist').should be_nil
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

    it "should create a new remedy if a git URL is given" do
      REPO = 'git@github.com:BlueFrogGaming/slime.git'
      remedy = ACD::Apothecary.potentize(REPO)
      remedy.should be_kind_of(ACD::Remedy)
      remedy.repository.should == REPO
    end

  end

end
