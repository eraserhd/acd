require 'fileutils'
require 'tmpdir'

PROJECT_ROOT = File.join(File.dirname(__FILE__),'..','..')

class Scenario

  class Environment
    attr_reader :root

    def initialize env
      @root = Dir.mktmpdir
      @env = {:ROOT => @root}.merge(env)
      make_git_repo(sample_project_path)
    end

    def cleanup
      FileUtils.remove_entry_secure @root
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

    def execute *args
      state = :no_state_available
      begin
        state = enter 
        if block_given?
          result = yield
        else
          result = system(args.first) && $? == 0
        end
        leave(state)
        result
      rescue Exception => e
        leave(state)
        raise e
      end
    end

    def expand s
      s.gsub(/\$[A-Za-z0-9_]+/) {|var| @env[var[1..-1].intern] || ""}
    end

  private
    def sample_project_path
      File.join(root, "project")
    end

    def current_state
      env = {}
      @env.keys.each {|k| env[k] = ENV[k.to_s]}
      [ Dir.getwd, env ] 
    end

    def enter
      old_state = current_state
      Dir.chdir(sample_project_path)
      @env.keys.each {|k| ENV[k.to_s] = @env[k]}
      old_state
    end

    def leave state
      Dir.chdir(state.first)
      state.last.keys.each {|k| ENV[k.to_s] = state.last[k]}
    end

    def git *args
      abort "Unable to run 'git #{args.join(' ')}'" unless system *(["git"] + args)
      abort "git error #{$?}" unless $? == 0
    end

  end

  def initialize
    @environment = Environment.new({:RUBYLIB => path_prepend(lib_path, ENV['RUBYLIB']),
                                    :PATH => path_prepend(bin_path, ENV['PATH'])})
  end

  def make_third_party_repo path
    @environment.make_git_repo(@environment.expand(path))
  end

  def run_command command
    abort "Failed to execute '#{command}'" unless @environment.execute(@environment.expand(command))
  end

  def cleanup
    @environment.cleanup
  end

  def is_clone? source_repo, target_repo
    source_readme = File.join(@environment.expand(source_repo), 'README')
    target_readme = File.join(@environment.expand(target_repo), 'README')
    @environment.execute do
      return false unless File.exist?(source_readme)
      return false unless File.exist?(target_readme)
      File.open(source_readme,'r') {|f| f.read} == File.open(target_readme,'r') {|f| f.read}
    end
  end
  
  def submodule? path
    @environment.execute do
      return false unless File.exist?('.gitmodules')
      contents = File.open('.gitmodules', 'r') {|f| f.read}
      contents =~ /\[submodule "#{path}"\]/
    end
  end

private
  def bin_path
    File.join(PROJECT_ROOT,'bin')
  end

  def lib_path
    File.join(PROJECT_ROOT,'lib')
  end

  def path_prepend(what, original)
    if original
      what + File::PATH_SEPARATOR + original
    else
      what
    end
  end

end
