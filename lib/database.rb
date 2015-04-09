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
      DataObjects::Connection.new(@config.connection_string)
    end
  end

  class DriverNotSupported < StandardError; end
  class ConnectionError < StandardError; end
end
