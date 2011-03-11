use Rack::ShowExceptions

require 'sinatra'
 
Sinatra::Application.set(:run, false)
Sinatra::Application.set(:env, 'production')

require './app'
app = App.new
run app
