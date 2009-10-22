require 'trucker'

set :environment, :production
set :run, false

run Sinatra::Application
