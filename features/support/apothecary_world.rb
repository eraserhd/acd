require 'acd/remedy'
require 'acd/cage'
require 'fileutils'
require 'shellwords'
require 'stringio'
require 'pp'

require File.join(File.dirname(__FILE__),'git_world')
require File.join(File.dirname(__FILE__), 'xcode_world')

PROJECT_ROOT = File.join(File.dirname(__FILE__),'..','..')
BIN_PATH = File.join(PROJECT_ROOT,'bin')
LIB_PATH = File.join(PROJECT_ROOT,'lib')

module ApothecaryWorld
  include GitWorld
  include XcodeWorld
  include Aruba::Api
  
  def boot_cage
    prepend_to_path_env 'RUBYLIB', LIB_PATH
    prepend_to_path_env 'PATH', BIN_PATH
    set_env 'ROOT', full_path_of('.')
    create_dir 'apothecary'
    set_env 'ACD_APOTHECARY', full_path_of('apothecary')
    make_git_repo 'project'
    cd 'project'
    @remedy_text = ""
  end

  def write_remedy name, file_content
    write_file(File.join(ENV['ACD_APOTHECARY'], "#{name}.rb"), expand(file_content))
  end

end

World(ApothecaryWorld)
