$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'

# Dependencies
require 'flog'
require 'shamazing'
require 'sinatra/base'
require 'mustache/sinatra'
require 'redis'
require 'resque'
require 'rugged'
require 'yajl'

# App
require 'app'

# Models
require_relative 'models/probe'
require_relative 'models/project'
require_relative 'models/repository'
require_relative 'models/source'

# Non-autoloaded views
require_relative 'views/layout'
require_relative 'views/aggregate'
require_relative 'views/project'

# Extensions
require_relative '../lib/ext/array'

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