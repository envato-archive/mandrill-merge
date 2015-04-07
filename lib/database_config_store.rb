module Database
  class ConfigStore

    def initialize(store={})
      @@store = store
    end

    def self.default
      find('default')
    end

    def self.find(name)
      @@store[key(name)]
    end

    def save(config)
      options = { 'driver' => 'mysql', 'name' => 'default' }.merge(config)
      store[ key(options['name']) ] = ConfigItem.new(options).to_hash
    end

    def to_hash
      Hash[*store.keys.zip(store.values.map(&:to_hash)).flatten]
    end

    private
    def self.key(name)
      "db_#{name}".to_sym
    end

    def key(name)
      self.class.key(name)
    end

    def store
      @@store
    end
  end
end
