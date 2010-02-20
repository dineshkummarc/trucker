require 'rubygems'
gem 'sinatra', '0.9.4'
require 'sinatra'

gem 'mongo_mapper', '0.7'
require 'mongo_mapper'

MongoMapper.database = "trucker-#{ENV['RACK_ENV']}"

require 'models'

helpers do
  def partial(name, locals={})
    erb "_#{name}".to_sym, :layout => false, :locals => locals
  end
end

get '/' do
  erb :index
end

get '/p.js' do
  projects = Project.all(:order => :title.asc)
  {:html => {'#content' => partial(:projects, :projects => projects)}}.to_json
end

get '/p/:id.js' do
  project = Project.find!(params[:id])
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

post '/p/:id/s' do
  story = Project.find!(params[:id]).stories.build(params[:story])

  if story.save
    {:append => {'#stories' => partial(:story, :story => story)}}
  else
    {:errors => story.errors.full_messages}
  end.to_json
end

delete '/p/:id' do
  project = Project.find!(params[:id])
  project.destroy
  {:remove => ["#project_#{project.id}"]}.to_json
end