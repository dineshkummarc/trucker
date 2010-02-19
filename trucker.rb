require 'rubygems'
require 'sinatra'
require 'mongo_mapper'

MongoMapper.database = 'trucker-development'

class Project
  include MongoMapper::Document
  
  key :title, String, :required => true
end

helpers do
  def partial(name, locals={})
    erb "_#{name}".to_sym, :layout => false, :locals => locals
  end
end

get '/' do
  erb :index
end

get '/p.js' do
  projects = Project.all
  {:html => {'#content' => partial(:projects, :projects => projects)}}.to_json
end

get '/p/:id.js' do
  project = Project.find(params[:id])
  {:html => {'#content' => partial(:show, :project => project)}}.to_json
end

post '/p' do
  project = Project.new(params[:project])
  
  if project.save
    {:append => {'#projects' => partial(:project, :project => project)}}
  else
    {:errors => project.errors.full_messages}
  end.to_json
end