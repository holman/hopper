module Hopper
  class App < Sinatra::Base
    register Mustache::Sinatra

    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder, "#{dir}/frontend/public"
    set :static, true
    set :mustache, {
      :namespace => Hopper,
      :templates => "#{dir}/templates",
      :views => "#{dir}/views"
    }

    get '/' do
      mustache :home
    end

    get '/projects' do
      @projects = Project.all
      mustache :projects
    end

    get '/projects/:id' do
      @project = Project.find(params[:id])
      mustache :project
    end
  end
end