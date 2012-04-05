$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'

# Dependencies
require 'flog'
require 'shamazing'
require 'sinatra/base'
require 'mustache/sinatra'
require 'redis'
require 'resque'
require 'ruby_parser'
require 'rugged'
require 'yajl'

# App
require 'app'

# Models
require 'models/probe'
require 'models/project'
require 'models/source'

# Non-autoloaded views
require 'app/views/layout'
require 'app/views/aggregate'
require 'app/views/project'

# Extensions
require 'lib/ext/array'

# Connect to Redis
$redis = Redis.connect(:url => 'redis://127.0.0.1', :thread_safe => true)
Resque.redis = $redis

module Hopper
  # The temporary directory that we can extract downloads to.
  #
  # Returns a relative String path.
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