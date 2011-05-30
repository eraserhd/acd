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
  include Aruba::Api
  
  def boot_cage
    prepend_to_path_env 'RUBYLIB', LIB_PATH
    prepend_to_path_env 'PATH', BIN_PATH
    set_env 'ROOT', full_path_of('.')
    set_env 'ACD_APOTHECARY', full_path_of('apothecary')
    create_dir 'apothecary'
    make_git_repo 'project'
    cd 'project'
    @remedy_text = ""
  end

  def make_remedy name
    @remedy_name = name
    @remedy_text = ""
    add_remedy_text <<-EOS
      remedy.name = '#{name}'
    EOS
  end

  def save_remedy
    in_current_dir do
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
    value = expand(value) if value.kind_of?(String)
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

end

World(ApothecaryWorld)
