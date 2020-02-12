module Nuago
  # An interface, you have to become.
  class EventStore
    @@repository = []
    
    def self.insert_events(events)
      @@repository.concat(events)
    end

    def self.by_aggregate_key(aggregate_key)
      @@repository.select do |event|
        event.aggregate_key == aggregate_key
      end
    end

    def self.by_event_name(event_name)
      @@repository.select do |event|
        event.event_name == event_name
      end
    end

    def self.all
      @@repository
    end
  end
end