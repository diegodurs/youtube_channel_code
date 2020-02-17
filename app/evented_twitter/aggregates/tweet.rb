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

      def initialize(aggregate_id)
        @aggregate_id = aggregate_id
        @aggregate_version = -1 # 0 will be the first aggregate_version
        @new_version = nil
        @new_events = []
      end

      def tweet_this(data)
        schema = {
          tweet: {
            user_id: Nuago::Schema::UUID.new, 
            text: Nuago::Schema::String.new(limit: 283)
          }
        }
        
        errors = Nuago::Schema.validate_presence_and_type(data: data, schema: schema)
        raise ArgumentError, "Schema errors: #{errors}" if errors.any?
        clean_data = Nuago::Schema.clean_unknwon_keys(data: data, schema: schema)
        
        add_event :tweet_was_tweeted, clean_data
        
        self
      end

      def add_event(event_name, data)
        @new_version = @aggregate_version + 1
        
        metadata = {
          aggregate_id: @aggregate_id, 
          aggregate_type: 'Tweet',
          aggregate_version: @new_version
        }
        @new_events << Nuago::GenericEvent.new(:tweet_was_tweeted, data, metadata)
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