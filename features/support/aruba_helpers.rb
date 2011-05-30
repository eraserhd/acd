
require 'aruba/api'

module Aruba
  module Api

    def expand s
      s.gsub(/\$[A-Za-z0-9_]+/) {|var| ENV[var[1..-1]] || ""}
    end

    def full_path_of path
      path = expand path
      if path.start_with?('/')
        path
      else
        File.join(Dir.getwd, current_dir, path)
      end
    end

    def prepend_to_path_env name, value
      name = name.to_s
      if ENV[name]
        set_env name, value + File::PATH_SEPARATOR + ENV[name]
      else
        set_env name, value
      end
    end

    # Expand shell variables before running commands
    unless instance_methods.include?(:aruba_run)
      alias_method :aruba_run, :run
      define_method(:run) do |cmd|
        aruba_run(expand(cmd))
      end
    end

  end
end
