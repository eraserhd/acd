require 'acd/remedy'
require 'acd/cage'
require 'fileutils'
require 'shellwords'
require 'stringio'
require 'pp'

require File.join(File.dirname(__FILE__),'git_world')

PROJECT_ROOT = File.join(File.dirname(__FILE__),'..','..')
BIN_PATH = File.join(PROJECT_ROOT,'bin')
LIB_PATH = File.join(PROJECT_ROOT,'lib')

module ApothecaryWorld
  include GitWorld
  
  def boot_cage
    @cage = ACD::Cage.new
    @cage.execute do
      prepend_path :RUBYLIB, LIB_PATH
      prepend_path :PATH, BIN_PATH
      ENV['ACD_APOTHECARY'] = File.join(@cage.root, 'apothecary')
      Dir.mkdir('apothecary')
      make_git_repo('project')
      Dir.chdir('project')
    end
    @remedy_text = ""
  end

  def prepend_path name, value
    name = name.to_s
    if ENV[name]
      ENV[name] = value + File::PATH_SEPARATOR + ENV[name]
    else
      ENV[name] = value
    end
  end
  private :prepend_path

  def dispose_cage
    @cage.dispose if @cage
  end

  def run_command command
    abort "Failed to execute '#{command}'" unless @cage.execute(command)
  end

  def self.run_method_in_cage *methods
    methods.each do |method_name|
      m = instance_method(method_name)
      define_method(method_name) do |*args|
        @cage.execute do
          m.bind(self).call(*args)
        end
      end
    end
  end

  def file_exists? file
    File.exists?(@cage.expand(file))
  end
  run_method_in_cage :file_exists?

  def make_remedy name
    @remedy_name = name
    @remedy_text = ""
    add_remedy_text <<-EOS
      remedy.name = '#{name}'
    EOS
  end

  def save_remedy
    File.open(File.join(ENV['ACD_APOTHECARY'], "#{@remedy_name}.rb"),"w") do |f|
      f << "ACD::Remedy.new do |remedy|\n"
      f << "#{@remedy_text}\n"
      f << "end\n"
    end
  end
  run_method_in_cage :save_remedy
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
  
  run_method_in_cage :submodule?

  def has_uncommitted_changes? *args
    return !changed_files.empty? if args.empty?
    changed_files.include?(args.first)
  end

  def last_log_message_contains? text
    last_log_message.include?(text)
  end

  run_method_in_cage :changed_files, :last_log_message

end

World(ApothecaryWorld)
