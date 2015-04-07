require 'do_mysql'

module Database
  @connection = nil
  @config = nil

  def self.connection
    @connection || begin
      @config = ConfigStore.default
      connect
    rescue DataObjects::SQLError
      #connection didn't work
      #raise ConnectionError
    end
  end

  private
  def self.connect
    unless @config.empty?
      raise DriverNotSupported unless @config.driver == 'mysql' 
      @connection = DataObjects::Connection.new(connection_string)
    end
  end

  def self.connection_string
    "#{@config.driver}://#{@config.username}:#{@config.password}@#{@config.host}:#{@config.port}/#{@config.database}"
  end

  class DriverNotSupported < StandardError; end
  class ConnectionError < StandardError; end
end
