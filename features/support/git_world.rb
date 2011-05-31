
require File.join(File.dirname(__FILE__),'aruba_helpers')
require 'aruba/cucumber'

module GitWorld

  def git *args
    output = IO.popen(['git', *args].shelljoin, "r") {|pipe| pipe.read}
    abort "git error #{$?}" unless $? == 0
    output
  end

  def make_git_repo path
    in_current_dir do
      Dir.mkdir(path)
      Dir.chdir(path) do
        git "init"
        File.open("README","w") {|f| f.write("A readme file - #{rand}")}
        git "add", "README"
        git "commit", "-m", "Initial commit"
      end
    end
  end

  def commit_file_to_repo repo, path, contents
    in_current_dir do
      Dir.chdir(expand(repo)) do
        File.open(path, "wb") {|f| f.write(contents)}
        git "add", path
        git "commit", "-m", "Add #{path}"
      end
    end
  end

  def make_third_party_repo path
    make_git_repo(full_path_of(path))
  end

  def is_clone? source_repo, target_repo
    prep_for_fs_check do
      source_readme = File.join(expand(source_repo), 'README')
      target_readme = File.join(expand(target_repo), 'README')
      return false unless File.exist?(source_readme)
      return false unless File.exist?(target_readme)
      File.read(source_readme) == File.read(target_readme)
    end
  end
  
  def submodule? path
    prep_for_fs_check do
      return false unless File.exist?('.gitmodules')
      contents = File.read '.gitmodules'
      contents =~ /\[submodule "#{path}"\]/
    end
  end

  def changed_files
    prep_for_fs_check do
      git("status", "--short").split(/\r?\n/).map{|l| l.gsub(/^..[ \t]*/, "")}
    end
  end

  def last_log_message
    prep_for_fs_check do
      git "log", "-1", "--oneline"
    end
  end

  def has_uncommitted_changes? *args
    return !changed_files.empty? if args.empty?
    changed_files.include?(args.first)
  end

  def last_log_message_contains? text
    last_log_message.include?(text)
  end

end

