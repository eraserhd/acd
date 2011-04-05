require 'rubygems'

task :default => :features

begin
  require 'cucumber'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format pretty --profile features"
  end
  Cucumber::Rake::Task.new(:wip) do |t|
    t.cucumber_opts = "--format pretty --profile wip"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available (cucumber not installed).'
  end
end
