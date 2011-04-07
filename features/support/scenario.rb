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
      initialize_git_repo(expand_variables(path))
    end
  end

  def run_command command
    set_environment_variables
    in_sample_project do
      with_bin_in_path do
        abort "Failed to execute '#{command}'" unless system(command)
      end
    end
  end

  def cleanup
    FileUtils.remove_entry_secure @path
  end

  def is_clone? source_repo, target_repo
    source_readme = File.join(expand_variables(source_repo), 'README')
    target_readme = File.join(expand_variables(target_repo), 'README')

    in_sample_project do
      return false unless File.exist?(source_readme)
      return false unless File.exist?(target_readme)

      File.open(source_readme,'r') {|f| f.read} == File.open(target_readme,'r') {|f| f.read}
    end
  end

private
  def set_environment_variables
    ENV['ROOT'] = @path
  end

  def expand_variables s
    set_environment_variables
    s.gsub(/\$[A-Za-z0-9_]+/) {|var| ENV[var[1..-1]] || ""}
  end

  def my_root
    File.join(File.dirname(__FILE__),'..','..')
  end

  def bin_path
    File.join(my_root,'bin')
  end

  def lib_path
    File.join(my_root,'lib')
  end

  def with_bin_in_path
    old_path = ENV['PATH']
    old_rubylib = ENV['RUBYLIB']
    ENV['PATH'] = bin_path + File::PATH_SEPARATOR + ENV['PATH']
    if old_rubylib
      ENV['RUBYLIB'] = lib_path + File::PATH_SEPARATOR + ENV['RUBYLIB']
    else
      ENV['RUBYLIB'] = lib_path
    end
    begin
      yield
    rescue Exception => e
      ENV['PATH'] = old_path 
      ENV['RUBYLIB'] = old_rubylib
      raise e
    end
    ENV['PATH'] = old_path 
    ENV['RUBYLIB'] = old_rubylib
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
