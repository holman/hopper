require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
Bundler.require(:default, :test)

require 'test/unit'
require 'test/spec/mini'
require 'rack/test'

ENV['RACK_ENV'] = 'test'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))

require 'boot'
include Hopper
include Rack::Test::Methods

# Select a new db to keep our data separate
$redis.select 12

# Extract the sample repo
if !File.exist?('test/examples/simple')
  system "tar xvzf test/examples/simple.tgz"
end

def app
  Hopper::App
end

# Set the fixture repository for this set of tests.
def fixture(project)
  path = "test/examples/#{project}"

  Hopper::Project.instance_eval do
    define_method(:path) do
      path
    end
  end

  Hopper::Github.instance_eval do
    define_method(:repo) do
      Rugged::Repository.new(path)
    end
  end
end