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

__END__

@@ layout
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title>Trucker</title>
  <link rel="stylesheet" href="/css/common.css" type="text/css" media="screen" charset="utf-8" />
  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js"></script>
  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js"></script>
  <script type="text/javascript" src="/js/sammy/sammy.js"></script>
  <script type="text/javascript" src="/js/jquery.form.js"></script>
  <script type="text/javascript" src="/js/layout.js"></script>
  <script type="text/javascript" src="/js/application.js"></script>
</head>
<body>

  <div id="wrapper">
    <%= yield %>
  </div>
</body>
</html>

@@ _show
<h2><a href="#/">Projects</a> &raquo; <%= project.title %></h2>

<form action="/p/<%= project.id %>/s" method="post" class="creator">
  <p>
    <input type="text" name="story[body]" value="" id="story_body" size="47" />
    <input type="submit" name="submit" value="Add" />
  </p>
</form>

<ul id="stories" class="list">
  <% project.stories.each do |story| %>
    <%= partial('story', :story => story) %>
  <% end %>
</ul>

@@ _story
<li id="story_<%= story.id %>">
  <%= story.body %>
</li>

@@ _project
<li id="project_<%= project.id %>">
  <a href="/p/<%= project.id %>" class="delete">Delete</a>
  <a href="#/p/<%= project.id %>"><%= project.title %></a>
</li>

@@ _projects
<form action="/p" method="post" class="creator">
  <p>
    <input type="text" name="project[title]" value="" id="project_title" size="30" />
    <input type="submit" name="submit" value="Create Project" />
  </p>
</form>

<ul id="projects" class="list">
  <% projects.each do |project| %>
    <%= partial('project', :project => project) %>
  <% end %>
</ul>

@@ index
<div id="content"></div>