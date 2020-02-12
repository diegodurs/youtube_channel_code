module EventedTwitter
  module UserTweets
    def self.for_user(query_params)
      events = Nuago::EventStore.by_event_name(:tweet_was_tweeted)
      events.map {|event| event.data[:tweet]}
    end

    def self.project(event)
      # using the EventStore as the Read Model db, we're not 
      # implementing CQRS.
      # This is the special case of Event-Sourcing without CQRS:
      # you use the same data source for both read/write 
      # side and you endup querying events by message name, or as we'll see
      # by aggregate_key.
    end
  end
end