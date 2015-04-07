class App < Sinatra::Application

  enable :sessions

  get '/' do
    redirect '/mail-merge'
  end

  get '/mail-merge' do
    erb :mail_merge
  end

  before do
    Database::ConfigStore.new(session)
  end

  post '/db/create' do
    logger.info "DB connection with #{ params.dup.tap{|p| p['password'] = 'REDACTED'} }"
    Database::ConfigStore.new(session).save(params)
    redirect "/db/test"
  end

  get '/db/test' do
    begin
      { can_connect: true, message: "Connection info: #{Database.connection}" }
    rescue StandardError => e
      { can_connect: false, message: e.message }
    end.to_json
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
