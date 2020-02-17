module Nuago
  module Reducer

    # extend a state object with standard behaviours
    def self.init_state
      state = {}

      def state.exists?
        state[:aggregate_key].present?
      end

      state
    end

    def self.reduce(state: {}, events: [], fcts: {})
      events.each do |event|
        state = reduce_step(state, event, fcts[event.event_name])
      end
      state
    end

    def self.reduce_step(state, event, fct)
      state[:aggregate_key] ||= event.aggregate_key
      state[:aggregate_version] = event.aggregate_version
      state[:aggregate_type] = event.aggregate_type
      
      state[:created_at] ||= event.timestamp
      state[:updated_at] = event.timestamp
      
      state = fct.call(event, state)
    end
  end
end