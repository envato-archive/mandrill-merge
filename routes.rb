class App < Sinatra::Application

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