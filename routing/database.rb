module Sinatra
  module App::Routing::Database
    def self.registered(app)
      index = -> {
        erb 'db/index'
      }

      app.get '/db', &index
    end
  end
end
