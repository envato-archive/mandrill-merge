require 'do_mysql'

class Database
  class << self
    attr_accessor :connection

    def connect(user:, pass:, host:, port:, database:)
      pass = nil if pass == ""
      @@connection = DataObjects::Connection.new("mysql://#{user}:#{pass}@#{host}:#{port}/#{database}")
    end
  end

end
