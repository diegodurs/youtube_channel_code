module Nuago
  class GenericEvent
    attr_reader :event_name, :data, :metadata
    def initialize(event_name, data, metadata)
      @event_name, @data, @metadata = event_name, data, metadata
    end
  end
end