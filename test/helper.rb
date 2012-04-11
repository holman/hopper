require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
Bundler.require(:default, :test)

require 'test/unit'
require 'rack/test'
require_relative 'spec/mini'

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
#
# This also sets up instance variables for accessing that repository. It grabs
# the HEAD revision of the repo and preps probes to use that.
def fixture(project)
  klass = Hopper.const_get(self.class.name)
  path = "test/examples/#{project}"
  repo = Rugged::Repository.new(path)

  Project.any_instance.stubs(:path).returns(path)
  Github.any_instance.stubs(:local_path).returns(path)

  @project = Hopper::Project.new('github.com/holman/hopper')

  # Don't create a new project if we're actually *testing* Project.
  if klass != Hopper::Project
    @probe = klass.new(@project)
  end

  revision = repo.head.target
  @probe.stubs(:revision).returns(revision)
end