module Nuago
  class Aggregate
    def self.load_aggregate(id)
      events = Nuago::EventStore.by_aggregate_id(id)
      new(id, events)
    end

    def self.validate_schema!(data:, schema:)
      errors = Nuago::Schema.validate(data: data, schema: schema)
      raise ArgumentError, "Schema errors: #{errors}" if errors.any?
      
      unknwon_keys = Nuago::Schema.unknwon_keys(data: data, schema: schema)
      raise ArgumentError, "Unexpected keys: #{unknwon_keys}" if unknwon_keys.any?

      return data
    end

    def self.clean_validate_schema!(data:, schema:)
      errors = Nuago::Schema.validate(data: data, schema: schema)
      raise ArgumentError, "Schema errors: #{errors}" if errors.any?
      
      clean_data = Nuago::Schema.clean_unknwon_keys(data: data, schema: schema)
      return clean_data
    end

    def initialize(aggregate_id, events = [])
      @aggregate_id = aggregate_id
      @aggregate_version = -1 # 0 will be the first aggregate_version
      @persisted_events = events
      @new_version = nil
      @new_events = []
    end

    def add_event(event_name, data)
      @new_version = @aggregate_version + 1
      
      metadata = {
        aggregate_id: @aggregate_id, 
        aggregate_type: aggregate_type,
        aggregate_version: @new_version
      }

      if defined?(Schemas) and Schemas.key?(event_name)
        schema = Schemas[event_name]
        data = self.class.clean_validate_schema!(data: data, schema: schema)
      end

      @new_events << Nuago::GenericEvent.new(event_name, data, metadata)
    end

    def aggregate_type
      self.class.name.split('::').last
    end

    def state
      @state ||= reducer.reduce(@persisted_events)
    end

    def unsaved_state
      reducer.reduce(new_events, state: state)
    end

    def reducer
      EventedTwitter.reducer_for(aggregate_type)      
    end

    # it's either a causation_message, or a request_context,
    # never both ...
    # request_context should hold a current_user_id and a session_id
    def save(causation_message: nil, request_context: nil)
      Nuago::EventStore.insert_events(@new_events, 
        causation_message: causation_message, 
        request_context: request_context
      )
      @state = nil
    end
  end
end