module Dynasore
  class Configuration
    # Because Singletons are hard to test, just make one instance preferred
    def self.instance
      @__instance__ ||= new
    end

    # Intent is that (a) the configuration file name is settable,
    # yet (b) assignments happen *after reading*, and
    # (c) there is no need to tell the instance to read the file
    def self.configurable_attr(*symbol_list)
      symbol_list.each do |symbol|
        define_method :"#{symbol}=" do |value|
          configure
          instance_variable_set("@#{symbol}", value)
        end

        define_method symbol do
          configure
          instance_variable_get("@#{symbol}")
        end

        Dynasore::Configuration.instance_eval %(
          def self.#{symbol}
            instance.#{symbol}
          end
        )
      end
    end

    configurable_attr :read_capacity_units, :write_capacity_units, :table_name_prefix
    class << self
      delegate :dynamo_table, to: :instance
    end

    def dynamo_table(string)
      table_name_prefix.present? ? "#{table_name_prefix}.#{string}" : string
    end

    attr_writer :config_file
    def config_file
      @config_file ||= File.join(Rails.root, 'config', 'dynamodb.yml')
    end

    attr_writer :env
    def env
      @env ||= if defined?(Rails)
          Rails.env
        else
          :test
        end
    end

    def configure
      @configured || begin
        # Parser calls assigners which call configure which calls parser...
        @configured = true
        parse_config_file(config_file) if File.exist?(config_file)
      end
    end

    def parse_config_file(config_file)
      if config_file && File.exist?(config_file)

        hash = YAML.load(ERB.new(File.read(config_file)).result)

        raise ArgumentError, 'Configuration file must yield a hash' unless hash.is_a?(Hash)

        hash[env].each_pair do |key, value|
          writer = :"#{key}="

          send(writer, value) if respond_to?(writer)
        end
      end
    end
  end
end
