require 'fileutils'
require 'tmpdir'

class Scenario
  attr_reader :path
  attr_accessor :working_directory

  def initialize
    @path = Dir.mktmpdir
    @working_directory = @path
  end

  def project_path
    File.join(path, "project")
  end

  def make_sample_project
    Dir.mkdir(project_path)
    Dir.chdir(project_path) do
      git "init"
      File.open("README","w") {|f| f.write("A readme file")}
      git "add", "README"
      git "commit", "-m", "Initial commit"
    end
  end

  def cleanup
    FileUtils.remove_entry_secure @path
  end

private
  def git *args
    abort "Unable to run 'git #{args.join(' ')}'" unless system *(["git"] + args)
    abort "git error #{$?}" unless $? == 0
  end

end
