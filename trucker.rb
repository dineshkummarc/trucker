require 'rubygems'
require 'sinatra'
require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, :auto_reconnect => true)
MongoMapper.database = 'trucker-development'
MongoMapper.ensure_indexes!

class Project
  include MongoMapper::Document
  
  key :title, String, :required => true
end

# class Story
#   include MongoMapper::Document
#   
#   key :project_id, String
#   key :title, String
#   key :description, String
#   key :points, Integer
# end

get '/' do
  @projects = Project.all
  erb :index
end

get '/projects.json' do
  Project.all.to_json
end

post '/projects' do
  project = Project.new(params[:project])
  
  if project.save
    project
  else
    {:errors => project.errors.full_messages}
  end.to_json
end