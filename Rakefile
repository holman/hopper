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
  Hopper::Project.create('github.com/holman/boom')
  Hopper::Project.create('github.com/holman/play')
  Hopper::Project.create('github.com/github/github-services')
  Hopper::Project.create('github.com/defunkt/mustache')
  Hopper::Project.create('github.com/mojombo/jekyll')
  Hopper::Project.create('github.com/rails/rails')
end

namespace :redis do
  desc "Wipe all data in redis"
  task :reset do
    $redis.flushdb
  end
end

namespace :resque do
  desc "Start resque-web"
  task :web do
    exec 'resque-web -p 8282'
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