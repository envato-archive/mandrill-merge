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
    @db_connection = Database::ConfigStore.default
    @db_query      = session[:db_query]
    @merge_tags    = session[:merge_tags] || []

    erb :mail_merge
  end

  post '/verify-mandrill' do
    content_type :json
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
    content_type :json
    return {can_connect: false, message: I18n.t(:enter_key), goto_section: 'connect_mandrill'}.to_json unless session[:key]
    mandrill = Mandrill.new(session[:key])
    begin
      response = mandrill.fetch_merge_tags(params[:template])
      session[:template] = params[:template]
      session[:merge_tags] = response unless response.empty?

      if session[:merge_tags]
        merge_tags_list = "<i>Unique ID, Recipient Email, "
        session[:merge_tags].each do |tag|
          merge_tags_list << "#{tag}, "
        end
        merge_tags_list = merge_tags_list[0..-3] + "</i>"
      end

      {success: true, message: session[:template], merge_tags: merge_tags_list||''}
    rescue StandardError => e
      {success: false, message: e.message}    
    end.to_json
  end

  post '/db/create' do
    logger.info "DB connection with #{ params.dup.tap{|p| p['password'] = 'REDACTED'} }"
    Database::ConfigStore.save(params)
    redirect "/db/test"
  end

  get '/db/test' do
    content_type :json
    begin
      { can_connect: true, message: "Connection info: #{Database.connection}" }
    rescue StandardError => e
      { can_connect: false, message: e.message }
    end.to_json
  end

  post '/set-db-query' do
    content_type :json
    session[:db_query] = params[:db_query]
    begin
      command = Database.connection.create_command(params[:db_query])
      data_rows = []
      command.execute_reader.take(20).each{|row| data_rows << row.values }
      {
        success: true,
        message: "#{command.execute_reader.count} records returned",
        data: { fields: command.execute_reader.fields, rows: data_rows }
      }
    rescue StandardError => e
      { success: false, message: e.message }
    end.to_json
  end

  post '/send-test' do
    content_type :json
    return {:can_connect => false, :message => I18n.t(:enter_key), :goto_section => 'connect_mandrill'}.to_json unless session[:key]
    return {:can_connect => false, :message => I18n.t(:select_template), :goto_section => 'select_template'}.to_json unless session[:template]
    return {:success => false, :message => I18n.t(:enter_email)}.to_json unless valid_email?(params[:email])
    mandrill = Mandrill.new(session[:key])
    return {:can_connect => false, :message => I18n.t(:mandrill_cannot_connect), :goto_section => 'connect_mandrill'}.to_json unless mandrill.can_connect?

    begin
      command = Database.connection.create_command(session[:db_query])
      data_row = command.execute_reader.take(1).first.values
      merged_template_data = TemplateFieldMerger.merge_fields(session[:merge_tags], [data_row])
    rescue StandardError => e
      return {:can_connect => true, :success => false, :message => e.message}.to_json
    end

    response = mandrill.send_single_email(session[:template], params[:email], merged_template_data.first)
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
