module Nuago
  # An interface, you have to become.
  class EventStore
    @@repository = []
    
    def self.insert_events(events, causation_message: nil, request_context: nil)
      events.each do |event| 

        event.set_causation_message(causation_message) if causation_message
        event.set_request_context(request_context) if request_context
        
        event.persisted!(
          event_id: Nuago.new_uuid,
          timestamp: Nuago.now
        )
      end

      @@repository.concat(events)

      # puts "Saved #{events}"

      events
    end

    def self.by_aggregate_id(aggregate_id)
      events = @@repository.select do |event|
        event.aggregate_id == aggregate_id
      end

      # puts "loaded #{events.size} for #{aggregate_id}"

      events
    end

    def self.by_event_name(event_name)
      @@repository.select do |event|
        event.event_name == event_name
      end
    end

    def self.clear!
      @@repository = []
    end
  end
end