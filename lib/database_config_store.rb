module Database
  module ConfigStore

    def self.default
      find('default')
    end

    def self.find(name)
      store[key(name)] if store
    end

    def self.save(name='default', config)
      defaults = { driver: 'mysql' }
      store[key(name)] = ConfigItem.new(config.dup.merge(defaults))
    end

    def self.to_hash
      Hash[*store.keys.zip(store.values.map(&:to_hash)).flatten]
    end

    private
    def self.key(name)
      "db_#{name}".to_sym
    end

    def self.store
      @store ||= {}
    end
  end
end
