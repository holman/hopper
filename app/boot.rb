$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'

require 'redis'
require 'sinatra/base'
require 'mustache/sinatra'

require 'app'

require 'models/index'
require 'models/probe'
require 'models/project'
require 'models/source'

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