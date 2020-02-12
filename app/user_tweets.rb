module Tweetes::UserTweets
  def self.for_user(user_id, pagination)
    events = Nuago::EventStore.by_event_name('TweetWasTweeted')
    # events += Nuago::EventStore.by_event_name('TweetWasReweeted')
    events.sort_by! {|e| e.payload[:tweeted_at] }

    # let's hide infrastructure data.
    events.map {|event| event.payload[:tweet] }
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
