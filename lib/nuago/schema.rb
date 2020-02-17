require 'nuago/core_ext/deep_each'

module Nuago
  class Schema

    def self.validate(schema: , data:)
      errors = []
      schema.deep_each do |k, datatype| 
        value = data.deep_fetch(k)
        
        if value.nil? && !datatype.can_be_null?
          errors << [k, "must be present"]
        elsif !datatype.valid?(value)
          errors << [k, "`#{value}` is an invalid #{datatype}"]
        end
      end

      return errors
    end

    def self.clean_unknwon_keys(data: , schema:)
      clean_data = schema.dup
      schema.deep_each do |k, datatype| 
        clean_data.deep_assign(k, data.deep_fetch(k))
      end
      clean_data
    end

    def self.unknwon_keys(data: , schema:)
      _unknwon_keys = []
      data.deep_each do |k, _value| 
        _unknwon_keys << k unless schema.deep_fetch(k)
      end
      _unknwon_keys
    end

    # --- Datatypes ---

    class DataType
      def initialize(options = {})
        @options = {null: false}.merge(options)
      end

      def can_be_null?
        @options[:null]
      end

      def valid?(data)
        if !@options[:null]
          return false if data.nil? || data.empty?
        end
        true
      end
    end
    
    class UUID < DataType
      def valid?(data)
        return false unless data.is_a?(::String)

        uuid_regex = @options[:uuid_regex] || /^[0-9a-fA-F]{8}\-?[0-9a-fA-F]{4}\-?[0-9a-fA-F]{4}\-?[0-9a-fA-F]{4}\-?[0-9a-fA-F]{12}$/
        return !!data.match(uuid_regex)
      end
    end
    
    class String < DataType
      def valid?(data)
        return false unless data.is_a?(::String)

        if @options[:limit]
          return false if data.size > @options[:limit]
        end

        return true
      end
    end
  end
end