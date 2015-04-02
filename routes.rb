class App < Sinatra::Application

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