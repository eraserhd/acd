
module Git

  def git *args
    output = IO.popen(['git', *args].shelljoin, "r") {|pipe| pipe.read}
    abort "git error #{$?}" unless $? == 0
    output
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

  def submodule? path
    return false unless File.exist?('.gitmodules')
    contents = File.open('.gitmodules', 'r') {|f| f.read}
    contents =~ /\[submodule "#{path}"\]/
  end

  def changed_files
    git("status", "--short").split(/\r?\n/).map{|l| l.gsub(/^..[ \t]*/, "")}
  end

  def last_log_message
    git "log", "-1", "--oneline"
  end

end

