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

    before do
      @path = request.path_info

      halt mustache(:dead)
    end

    get '/' do
      mustache :index
    end

    get '/stats' do
      mustache :stats
    end

    get '/probes' do
      @probes = Probe.all
      mustache :probes
    end

    get '/probes/:id' do
      @probe = Probe.find(params[:id])
      mustache :probe, :layout => !request.xhr?
    end

    get '/probes/:id/raw' do
      @probe = Probe.find(params[:id])
      @probe.to_csv
    end

    get '/projects' do
      mustache :projects
    end

    # whatever, deal with this monstrocity later
    get '/projects/jump' do
      path = params[:url].gsub('https://github.com/','')
      @project = Project.find_by_name(path)
      if @project
        redirect "/projects/#{@project.id}"
      else
        redirect :projects
      end
    end

    get '/projects/:id' do
      @project = Project.find(params[:id])
      mustache :project
    end

    get '/projects/:id/:probe' do
      @project = Project.find(params[:id])
      @probe = @project.probes.select{|probe| probe.name == params[:probe]}.first
      mustache :project_probe, :layout => !request.xhr?
    end
  end
end