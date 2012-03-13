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

class Hopper::Project
  def path
    "test/examples/simple"
  end
end

def app
  Hopper::App
end