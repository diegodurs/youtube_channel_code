module EventedTwitter
  module Aggregates
    class Tweet
      def self.tweet_this(data)
        data[:tweet_id] = Nuago.new_uuid
        new(data[:tweet_id]).tweet_this(data)
      end


      # could be unpublished_events, unsaved_events, but simpler is better
      attr_reader :new_events

      def initialize(aggregate_key)
        @aggregate_key = aggregate_key
        @aggregate_version = 0
        @new_events = []
      end

      def tweet_this(data)
        metadata = {aggregate_key: @aggregate_key, aggregate_type: 'Tweet'}
        
        @new_version = @aggregate_version + 1
        @new_events << Nuago::GenericEvent.new(:tweet_was_tweeted, data, metadata)

        self
      end

      def save
        Nuago::EventStore.insert_events(@new_events)
      end
    end
  end
end