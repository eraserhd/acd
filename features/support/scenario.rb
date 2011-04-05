require 'fileutils'
require 'tmpdir'

class Scenario
  attr_reader :path
  attr_accessor :working_directory

  def initialize
    @path = Dir.mktmpdir
    @working_directory = @path
  end

  def sample_project_path
    File.join(path, "project")
  end

  def make_sample_project
    initialize_git_repo(sample_project_path) unless @sample_project_initialized
    @sample_project_initialized = true
  end

  def make_third_party_repo path
    in_sample_project do
      initialize_git_repo path
    end
  end

  def run_command command
    in_sample_project do
      with_bin_in_path do
        abort "Failed to execute '#{command}'" unless system(command)
      end
    end
  end

  def cleanup
    FileUtils.remove_entry_secure @path
  end

private
  def bin_path
    File.join(File.dirname(__FILE__),'..','..','bin')
  end

  def with_bin_in_path
    old_path = ENV['PATH']
    ENV['PATH'] = bin_path + File::PATH_SEPARATOR + ENV['PATH']
    begin
      yield
    rescue Exception => e
      ENV['PATH'] = old_path 
      raise e
    end
    ENV['PATH'] = old_path 
  end

  def in_sample_project
    make_sample_project
    Dir.chdir(sample_project_path) do
      yield
    end
  end
  
  def initialize_git_repo path
    Dir.mkdir(path)
    Dir.chdir(path) do
      git "init"
      File.open("README","w") {|f| f.write("A readme file - #{rand}")}
      git "add", "README"
      git "commit", "-m", "Initial commit"
    end
  end

  def git *args
    abort "Unable to run 'git #{args.join(' ')}'" unless system *(["git"] + args)
    abort "git error #{$?}" unless $? == 0
  end

end
