require File.expand_path(File.dirname(__FILE__) + '/app/boot')

require 'sprockets'
require 'resque/server'

stylesheets = Sprockets::Environment.new
stylesheets.append_path 'app/frontend/styles'

javascripts = Sprockets::Environment.new
javascripts.append_path 'app/frontend/scripts'

map('/resque') { run Resque::Server.new }
map("/css")    { run stylesheets }
map("/js")     { run javascripts }

map('/')    { run Hopper::App }