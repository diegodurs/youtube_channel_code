require 'evented_twitter/aggregates/tweet/messages'
require 'evented_twitter/aggregates/tweet/reducer'
require 'evented_twitter/aggregates/tweet/schema'

module EventedTwitter
  module Aggregates
    class Tweet
      def self.tweet_this(data)
        data[:tweet][:tweet_id] = Nuago.new_uuid
        new(data[:tweet][:tweet_id]).tweet_this(data)
      end


      # could be unpublished_events, unsaved_events, but simpler is better
      attr_reader :new_events

      def initialize(aggregate_key)
        @aggregate_key = aggregate_key
        @aggregate_version = 0 # 1 will be the first event / version
        @new_events = []
      end

      def tweet_this(data)
        @new_version = @aggregate_version + 1
        
        metadata = {
          aggregate_key: @aggregate_key, 
          aggregate_type: 'Tweet',
          aggregate_version: @new_version
        }
        @new_events << Nuago::GenericEvent.new(:tweet_was_tweeted, data, metadata)

        self
      end

      # it's either a causation_message, or a request_context,
      # never both ...
      # request_context should hold a current_user_id and a session_id
      def save(causation_message: nil, request_context: nil)
        Nuago::EventStore.insert_events(@new_events, 
          causation_message: causation_message, 
          request_context: request_context
        )
      end
    end
  end
end