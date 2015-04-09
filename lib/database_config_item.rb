module Database
  ConfigItem = Struct.new(:name, :host, :username, :password, :port, :driver, :database, :ca_cert) do
    def to_hash
      Hash[*members.map(&:to_s).zip(values).flatten]
    end

    def connection_string
      "#{driver}://#{username}:#{password}@#{host}:#{port}/#{database}".tap do |conn_string|
        conn_string << "?ssl[ca_cert]=#{ca_cert}" unless ca_cert.empty?
      end
    end

    def empty?
      values.all?(&:nil?)
    end

    def initialize(settings=nil)
      super()
      settings ||= {}
      self.driver   = settings['driver']
      self.name     = settings['name']
      self.host     = settings['host']
      self.port     = settings['port']
      self.ca_cert  = settings['ca_cert'].to_s
      self.database = settings['database']
      self.password = settings['password']
      self.username = settings['username']
      raise "CA CERT file not found" unless ca_cert.empty? || !File.exists?(ca_cert)
    end
  end
end
