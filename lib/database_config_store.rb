module Database
  class ConfigStore

    class << self
      def store=(_store={})
        @@store = _store
      end

      def default
        find('default')
      end

      def find(name)
        ConfigItem.new @@store[ key(name) ]
      end

      def save(config)
        options = { 'driver' => 'mysql', 'name' => 'default' }.merge(config)
        @@store[ key(options['name']) ] = ConfigItem.new(options).to_hash
      end

      private def key(name)
        "db_#{name}".to_sym
      end
    end
  end
end
