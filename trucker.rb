require 'rubygems'
gem 'sinatra', '0.9.4'
require 'sinatra/base'
require 'sinatra/json_verbs'
require 'models'

class Trucker < Sinatra::Base
  enable :static

  set :public, File.dirname(__FILE__) + '/public'
  set :views,  File.dirname(__FILE__) + '/views'
  
  register Sinatra::JsonVerbs

  helpers do
    def partial(name, locals={})
      erb "_#{name}".to_sym, :layout => false, :locals => locals
    end
  end

  get '/?' do
    erb :index
  end

  json_get '/p.js' do
    projects = Project.all(:order => :title.asc)
    {:html => {'#content' => partial(:projects, :projects => projects)}}
  end

  json_get '/p/:id.js' do
    project = Project.find!(params[:id])
    {:html => {'#content' => partial(:show, :project => project)}}
  end

  json_post '/p' do
    project = Project.new(params[:project])

    if project.save
      {:append => {'#projects' => partial(:project, :project => project)}}
    else
      {:errors => project.errors.full_messages}
    end
  end

  json_post '/p/:id/s' do
    story = Project.find!(params[:id]).stories.build(params[:story])

    if story.save
      {:append => {'#stories' => partial(:story, :story => story)}}
    else
      {:errors => story.errors.full_messages}
    end
  end

  json_delete '/p/:id' do
    project = Project.find!(params[:id])
    project.destroy
    {:remove => ["#project_#{project.id}"]}
  end
end