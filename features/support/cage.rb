require 'fileutils'
require 'tmpdir'

class Cage
  attr_reader :root, :working_directory

  def initialize
    @root = Dir.mktmpdir
    @working_directory = @root
    @env = {:ROOT => @root}
  end

  def dispose
    FileUtils.remove_entry_secure @root
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
      leave(state) unless state == :no_state_available
      raise e
    end
  end

  def expand s
    s.gsub(/\$[A-Za-z0-9_]+/) {|var| @env[var[1..-1].intern] || ""}
  end

private
  def current_state
    env = {}
    @env.keys.each {|k| env[k] = ENV[k.to_s]}
    [ Dir.getwd, env ] 
  end

  def enter
    old_state = current_state
    Dir.chdir(working_directory)
    @env.keys.each {|k| ENV[k.to_s] = @env[k]}
    old_state
  end

  def leave state
    @working_directory = Dir.getwd
    @env.merge!(ENV)
    Dir.chdir(state.first)
    state.last.keys.each {|k| ENV[k.to_s] = state.last[k]}
  end

end

