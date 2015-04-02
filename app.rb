require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/partial'
require 'json'
require 'sinatra/reloader' if development?
require 'redcarpet'

root = File.expand_path(File.dirname(__FILE__))
Dir[File.join(root, "/lib/**/*.rb")].each { |path| require path }

class App < Sinatra::Application
 
  register Sinatra::Partial
  enable :partial_underscores
  set :partial_template_engine, :erb
  
  enable :sessions

end

require_relative 'assets'
require_relative 'routes'
