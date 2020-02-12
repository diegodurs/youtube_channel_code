module EventedTwitter
  module Aggregates
    module Tweet
      class TweetAggregate
        def initialize(aggregate_id, events)
          @aggregate_id = aggregate_id
          @events = events
        end

        def tweet_this(data)
          data[:tweet][:tweet_id] ||= Nuago.new_uuid
          metadata[:aggregate_key] = data[:tweet][:tweet_id]
        
          event = TweetWasTweeted.new(data, metadata)
          
          Nuago::EventStore.transaction do
            Nuago::EventStore.insert_event(event)
          end
          
          return [0, event.name]
        end
      end
    end
  end
end