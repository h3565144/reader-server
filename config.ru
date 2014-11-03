require './config/env'
use Rack::MethodOverride
use Rack::Session::Cookie
run Rack::Cascade.new [API, Web]
# run Sinatra::Application
