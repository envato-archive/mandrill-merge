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

  enable :sessions

  get '/' do
    redirect '/mail-merge'
  end

  get '/mail-merge' do
    erb :mail_merge
  end

  post '/verify-mandrill' do
    session[:key] = params[:key]
    mandrill = Mandrill.new(session[:key])

    if mandrill.can_connect?
      message = "Connection successful: User is #{mandrill.username}"
    else
      message = 'Connection unsuccessful'
    end

    {:can_connect => mandrill.can_connect?, :message => message}.to_json
  end

  get '/docs' do
    erb :index
  end

end

require_relative 'assets'
require_relative 'routes'
require_relative 'helpers'
