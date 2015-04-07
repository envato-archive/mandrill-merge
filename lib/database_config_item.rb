module Database
  ConfigItem = Struct.new(:name, :host, :username, :password, :port, :driver, :database) do
    def to_hash
      Hash[*members.zip(values).flatten]
    end

    def initialize(settings={})
      super()
      self.driver   = settings['driver']
      self.name     = settings['name']
      self.host     = settings['host']
      self.port     = settings['port']
      self.database = settings['database']
      self.password = settings['password']
      self.username = settings['username']
    end
  end
end