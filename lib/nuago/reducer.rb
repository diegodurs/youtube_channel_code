module Nuago
  module Reducer

    # extend a state object with standard behaviours
    def self.init_state
      state = {}

      def state.exists?
        state[:aggregate_id].present?
      end

      state
    end

    def self.reduce(events, state: {}, fcts: {})
      events.each do |event|
        state = reduce_step(state, event, fcts[event.event_name])
      end
      state
    end

    def self.reduce_step(state, event, fct)
      state[:aggregate_id] ||= event.aggregate_id
      state[:aggregate_version] = event.aggregate_version
      state[:aggregate_type] = event.aggregate_type
      
      state[:created_at] ||= event.timestamp
      state[:updated_at] = event.timestamp

      if fct
        return_fct = fct.call(event, state) 
        
        if !return_fct.key?(:aggregate_id)
          raise ArgumentError, 'reducer function did not return the state obj'
        end

        state = return_fct
      end

      # this assignment must be after fct call to avoid
      # duplicated ids.
      state = self._add_aggregate_id(state, event)

      return state
    end

    def self._add_aggregate_id(state, event)
      id_as_sym = event.aggregate_type_to_sym
      if state.key?(:"#{id_as_sym}")
        state[:"#{id_as_sym}"][:"#{id_as_sym}_id"] ||= event.aggregate_id
      else
        state[:"#{id_as_sym}_id"] ||= event.aggregate_id
      end
      state
    end
  end
end