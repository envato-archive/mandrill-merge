require 'do_mysql'
require_relative 'database_config_item'

module Database
  @config = ConfigItem.new

  def self.connection
    begin
      connect(ConfigStore.default)
    rescue DataObjects::SQLError => e
      raise ConnectionError.new(e)
    end
  end

  private
  def self.connect(config)
    unless config.empty?
      @config = config
      raise DriverNotSupported unless @config.driver == 'mysql' 
      DataObjects::Connection.new(connection_string)
    end
  end

  def self.connection_string
    "#{@config.driver}://#{@config.username}:#{@config.password}@#{@config.host}:#{@config.port}/#{@config.database}"
  end

  class DriverNotSupported < StandardError; end
  class ConnectionError < StandardError; end
end
