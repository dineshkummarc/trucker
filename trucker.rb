require 'rubygems'
gem 'sinatra', '0.9.4'
require 'sinatra'

gem 'mongo_mapper', '0.7'
require 'mongo_mapper'

MongoMapper.database = 'trucker-development'

class Project
  include MongoMapper::Document
  key :title, String, :required => true
  
  many :stories
end

class Story
  include MongoMapper::Document
  
  key :body, String, :required => true
  key :project_id, ObjectId, :required => true, :index => true
  key :position, Integer, :default => 1
  
  belongs_to :project
  
  before_save :set_position
  
  private
    def set_position
      self.position = project.stories.map(&:position).max + 1
    end
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

delete '/p/:id' do
  project = Project.find!(params[:id])
  project.destroy
  {:remove => ["#project_#{project.id}"]}.to_json
end