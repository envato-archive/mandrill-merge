class App < Sinatra::Application

  enable :sessions

  get '/' do
    redirect '/mail-merge'
  end

  get '/mail-merge' do
    erb :mail_merge
  end

  post '/db/create' do
    logger.info "-"*80
    logger.info "DB connection with #{ params.dup.tap{|p| p['password'] = 'REDACTED'} }"
    session[:db] ||= {}
    session[:db][:username] = params['username']
    session[:db][:password] = params['password']
    session[:db][:database] = params['database']
    session[:db][:host] = params['host']
    session[:db][:port] = params['port']

    redirect 'mail-merge'
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

  post '/select-template' do
    session[:template] = params[:template]
    {:success => true, :message => session[:template]}.to_json
  end

  post '/set-db-query' do
    session[:db_query] = params[:db_query]
    {:success => true, :message => session[:db_query]}.to_json
  end

  get '/docs' do
    erb :index
  end

end
