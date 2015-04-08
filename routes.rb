class App < Sinatra::Application

  before do
    Database::ConfigStore.store = session
  end


  get '/' do
    redirect '/mail-merge'
  end

  get '/mail-merge' do
    @key           = session[:key]
    @template      = session[:template]
    @db_connection = Database::ConfigStore.default.to_hash
    @db_query      = session[:db_query]
    # @subquery      = session[:subquery]

    erb :mail_merge
  end

  post '/verify-mandrill' do
    session[:key] = params[:key]
    mandrill = Mandrill.new(session[:key])

    if mandrill.can_connect?
      message = "Connection successful: User is #{mandrill.username}"
    else
      message = I18n.t :mandrill_cannot_connect
    end

    {:can_connect => mandrill.can_connect?, :message => message}.to_json
  end

  post '/select-template' do
    session[:template] = params[:template]
    {:success => true, :message => session[:template]}.to_json
  end

  post '/db/create' do
    logger.info "DB connection with #{ params.dup.tap{|p| p['password'] = 'REDACTED'} }"
    Database::ConfigStore.save(params)
    redirect "/db/test"
  end

  get '/db/test' do
    begin
      { can_connect: true, message: "Connection info: #{Database.connection}" }
    rescue StandardError => e
      { can_connect: false, message: e.message }
    end.to_json
  end

  post '/set-db-query' do
    sql = session[:db_query] = params[:db_query]
    begin
      reader = Database.connection.create_command(sql).execute_reader
      { success: true, message: "#{reader.count} records returned" }
    rescue StandardError => e
      { success: false, message: e.message }
    end.to_json
  end

  post '/send-test' do
    return {:can_connect => false, :message => I18n.t(:enter_key), :goto_section => 'connect_mandrill'}.to_json unless session[:key]
    return {:can_connect => false, :message => I18n.t(:select_template), :goto_section => 'select_template'}.to_json unless session[:template]
    return {:success => false, :message => I18n.t(:enter_email)}.to_json unless valid_email?(params[:email])
    mandrill = Mandrill.new(session[:key])
    return {:can_connect => false, :message => I18n.t(:mandrill_cannot_connect), :goto_section => 'connect_mandrill'}.to_json unless mandrill.can_connect?
    response = mandrill.send_single_email(session[:template], params[:email], [{name: 'FULLNAMEORUSERNAME', content: 'King Kong'}])
    unless response[0]
      message = response["message"] || I18n.t(:mandrill_cannot_send)
      return {:can_connect => true, :success => false, :message => message}.to_json 
    end
    {:can_connect => true, :success => true, :message => I18n.t(:test_sent)}.to_json
  end

  get '/docs' do
    erb :index
  end

end
