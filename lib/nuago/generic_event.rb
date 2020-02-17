module Nuago
  class GenericEvent
    
    attr_reader :data, :metadata
    def initialize(event_name, data, metadata)
      @event_name = event_name
      @data = data
      @metadata = metadata
    end

    def aggregate_key
      metadata[:aggregate_key]
    end

    def aggregate_type
      metadata[:aggregate_type]
    end

    def aggregate_version
      metadata[:aggregate_version]
    end

    def timestamp
      metadata[:timestamp]
    end

    def current_user_id
      metadata[:current_user_id]
    end

    def event_name
      @event_name.to_sym
    end

    # not applicable in this example
    def set_causation_message(causation_msg)
      @metadata[:causation_id] = causation_msg.event_id
      @metadata[:correlation_id] = causation_msg.correlation_id || causation_msg.event_id
      self
    end

    def set_request_context(request_context)
      @metadata[:current_user_id] = request_context[:current_user_id]
      self
    end

    def persisted!(event_id: , timestamp: )
      raise ArgumentError, 'event_id already set' if @metadata[:event_id].present?
      @metadata[:event_id] = event_id
      @metadata[:timestamp] = timestamp
      self
    end
  end
end