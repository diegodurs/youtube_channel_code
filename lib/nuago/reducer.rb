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
        state = reduce_step(state, event, reduce_fcts[event.symbolized_name])
      end
      state
    end

    def self.reduce_step(state, event, fct)
      state[:aggregate_key] ||= event.aggregate_key
      state[:aggregate_version] = event.aggregate_version
      
      state[:created_at] ||= event.timestamp
      state[:updated_at] = event.timestamp
      
      state[:current_user_id] = event.current_user_id if event.current_user_id
      
      state = fct.call(event, state)
    end
  end
end