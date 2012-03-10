$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'

# Dependencies

require 'redis'
require 'sinatra/base'
require 'mustache/sinatra'

# App
require 'app'
require 'app/views/layout'

# Models
require 'models/index'
require 'models/probe'
require 'models/project'
require 'models/source'

# Extensions
require 'lib/ext/array'

$redis = Redis.connect(:url => 'redis://127.0.0.1', :thread_safe => true)

module Hopper
  def self.temp_dir
    'tmp'
  end

  # The redis namespace to put everything else under.
  #
  # Returns a String.
  def self.redis_namespace
    "hopper"
  end
end