require 'rubygems'
require 'rake'
require 'yaml'
require 'resque/tasks'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/app')

require 'boot'

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./app/boot"
end

desc "Sets up your install with some demo data"
task :setup do
  puts "Clearing your redis database"
  Rake::Task['redis:reset'].invoke

  puts "Generating some test data"
  Hopper::Project.new('github.com/holman/boom').save
  Hopper::Project.new('github.com/holman/play').save
  Hopper::Project.new('github.com/github/github-services').save
  Hopper::Project.new('github.com/defunkt/mustache').save
  Hopper::Project.new('github.com/twitter/bootstrap').save

  # Analyze everything
  Hopper::Project.all.each{|p| Hopper::Project.find(p).async_analyze }
end

namespace :redis do
  desc "Wipe all data in redis"
  task :reset do
    $redis.flushdb
  end
end

namespace :test do
  namespace :git do
    desc "Package repos"
    task :package do
      system "rm -rf test/examples/simple.tgz"
      system "tar cvzf test/examples/simple.tgz test/examples/simple"
    end
  end
end