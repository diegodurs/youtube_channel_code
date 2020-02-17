module EventedTwitter
  class UserTweet
    def self.for_user(data)
      events = Nuago::EventStore.by_event_name(:tweet_was_tweeted)
      # events += Nuago::EventStore.by_event_name('TweetWasReweeted')
      
      events.select! {|e| e.data[:tweet][:user_id] = data[:user_id]}

      entities = EventedTwitter.reduce_entities_from_events(events)

      tweets = entities.map {|_, h| h[:state] }
      tweets.sort_by! {|tweet| tweet[:created_at] }

      return tweets
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