module Nuago
  class Message
  end
  class Event < Message
    extend Forwardable

    def_delegators :@metadata, 
      :aggregate_key, :aggregate_type, :aggregate_version,
      :timestamp, 
      :message_id, :causation_id, :correlation_id

    def initialize(data, metadata = {})
      @data = data
      @metadata = metadata
    end

    def set_correlation(message)
      @metadata[:correlation_id] = message.correlation_id || message.message_id
      @metadata[:causation_id] = message.causation_id
    end

    def persisted!(message_id = nil)
      @metadata[:message_id] = message_id
    end
  end
end