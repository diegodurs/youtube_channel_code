module Nuago
  # An interface, you have to become.
  class EventStore
    @@repository = []
    
    def self.save(event)
      event.persisted!(Nuago.new_uuid)
      @@repository << event
    end

    def self.by_aggregate_key(aggregate_key)
      @@repository.select do |event|
        event.aggregate_key == aggregate_key
      end
    end

    def self.by_message_name(name)
      @@repository.select do |event|
        event.event_name == event_name
      end
    end
  end
end