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

  set :root, File.dirname(__FILE__)
  register Sinatra::AssetPack

  assets {
    serve '/js', from: 'assets/scripts'
    serve '/css', from: 'assets/stylesheets'
    serve '/images', from: 'assets/images'

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    # The final parameter is an array of glob patterns defining the contents
    # of the package (as matched on the public URIs, not the filesystem)
    js :application, '/js/app.js', [
        '/js/vendor/jquery.js',
        '/js/vendor/**/*.js',
        '/js/foundation/foundation.js',
        '/js/foundation/foundation.accordion.js',
        '/js/*.js'
    ]

    css :application, '/css/app.css', [
        '/css/vendor/normalize.css',
        '/css/foundation/foundation.css',
        '/css/*.css'
    ]

    js_compression :jsmin # :jsmin | :yui | :closure | :uglify
    css_compression :sass # :simple | :sass | :yui | :sqwish
  }

  get '/' do
    redirect '/mail-merge'
  end

  get '/mail-merge' do
    erb :mail_merge
  end

  post '/submit-api' do
    session[:key] = params[:key]
    redirect '/verify-mandrill'
  end

  get '/verify-mandrill' do
    mandrill = Mandrill.new(session[:key])
    @mandrill_details = {:can_connect => mandrill.can_connect?, :username => mandrill.username}
    erb :mail_merge
  end

  get '/docs' do
    erb :index
  end

end
