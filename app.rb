require 'sinatra/base'
require 'sinatra/assetpack'
require 'sinatra/partial'
require 'json'
require 'sinatra/reloader' if development?
require 'redcarpet'

root = File.expand_path(File.dirname(__FILE__))
LIB_PATH_GLOB = File.join(root, "lib/**/*.rb")
Dir[LIB_PATH_GLOB].each { |path| require path }

class App < Sinatra::Application
 
  register Sinatra::Partial
  enable :partial_underscores
  set :partial_template_engine, :erb
  
  also_reload LIB_PATH_GLOB

end

require_relative 'assets'
require_relative 'routes'
require_relative 'helpers'
require_relative 'messages'
