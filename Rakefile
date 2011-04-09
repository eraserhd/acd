require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "acd"
  gem.homepage = "http://github.com/BlueFrogGaming/acd"
  gem.license = "MIT"
  gem.summary = %Q{Apple Coder - Manage iOS projects with ease}
  gem.description = %Q{
    ACD manages third-party code in your iOS project, including importing and
    tracking them as git submodules.
  }
  gem.email = "jason.m.felice@gmail.com"
  gem.authors = ["Jason Felice"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'cucumber'
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty --profile features"
end
Cucumber::Rake::Task.new(:wip) do |t|
  t.cucumber_opts = "--format pretty --profile wip"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |t|
  t.spec_opts << '--color'
end

task :default => :features

