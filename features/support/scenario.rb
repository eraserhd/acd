require 'acd/remedy'
require 'acd/cage'
require 'fileutils'
require 'shellwords'
require 'stringio'
require 'pp'

PROJECT_ROOT = File.join(File.dirname(__FILE__),'..','..')
BIN_PATH = File.join(PROJECT_ROOT,'bin')
LIB_PATH = File.join(PROJECT_ROOT,'lib')

class Scenario

  def initialize
    @cage = ACD::Cage.new
    @cage.execute do
      ENV['RUBYLIB'] = path_prepend(LIB_PATH, ENV['RUBYLIB'])
      ENV['PATH'] = path_prepend(BIN_PATH, ENV['PATH'])
      ENV['ACD_APOTHECARY'] = File.join(@cage.root, 'apothecary')
      Dir.mkdir('apothecary')
      make_git_repo('project')
      Dir.chdir('project')
    end
    @remedy_text = ""
  end

  def dispose
    @cage.dispose
  end

  def make_third_party_repo path
    make_git_repo(@cage.expand(path))
  end

  def run_command command
    abort "Failed to execute '#{command}'" unless @cage.execute(command)
  end

  def file_exists? file
    @cage.execute { File.exists?(@cage.expand(file)) }
  end

  def make_remedy name
    @remedy_name = name
    @remedy_text = ""
    add_remedy_text <<-EOS
      remedy.name = '#{name}'
    EOS
  end

  def save_remedy
    @cage.execute do
      File.open(File.join(ENV['ACD_APOTHECARY'], "#{@remedy_name}.rb"),"w") do |f|
        f << "ACD::Remedy.new do |remedy|\n"
        f << "#{@remedy_text}\n"
        f << "end\n"
      end
    end
  end
  private :save_remedy

  def add_remedy_text text
    @remedy_text << text
    save_remedy
  end
  private :add_remedy_text

  def set_remedy_property name, value
    value = @cage.expand(value) if value.kind_of?(String)
    sio = StringIO.new("", 'w')
    PP.singleline_pp(value, sio)
    add_remedy_text <<-EOS
      remedy.#{name} = #{sio.string}
    EOS
  end

  def remedy_wants_xcode
    add_remedy_text <<-EOS
      remedy.xcode_project do |p|
      end
    EOS
  end

  def is_clone? source_repo, target_repo
    source_readme = File.join(@cage.expand(source_repo), 'README')
    target_readme = File.join(@cage.expand(target_repo), 'README')
    @cage.execute do
      return false unless File.exist?(source_readme)
      return false unless File.exist?(target_readme)
      File.open(source_readme,'r') {|f| f.read} == File.open(target_readme,'r') {|f| f.read}
    end
  end
  
  def submodule? path
    @cage.execute do
      return false unless File.exist?('.gitmodules')
      contents = File.open('.gitmodules', 'r') {|f| f.read}
      contents =~ /\[submodule "#{path}"\]/
    end
  end

  def has_uncommitted_changes? path
    changed_files.include?(path)
  end

  def last_log_message_contains? text
    last_log_message.include?(text)
  end

private
  def changed_files
    @cage.execute{git "status", "--short"}.split(/\r?\n/).map{|l| l.gsub(/^.[ \t]*/, "")}
  end

  def last_log_message
    @cage.execute{git "log", "-1", "--oneline"}
  end

  def path_prepend(what, original)
    if original
      what + File::PATH_SEPARATOR + original
    else
      what
    end
  end

  def make_git_repo path
    Dir.mkdir(path)
    Dir.chdir(path) do
      git "init"
      File.open("README","w") {|f| f.write("A readme file - #{rand}")}
      git "add", "README"
      git "commit", "-m", "Initial commit"
    end
  end

  def git *args
    result = IO.popen(['git', *args].shelljoin, "r") {|pipe| pipe.read}
    abort "git error #{$?}" unless $? == 0
    result
  end

end
