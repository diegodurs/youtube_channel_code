module EventedTwitter
  module Aggregates
    class Tweet < Nuago::Aggregate
      Schemas = {
        tweet_was_tweeted: {
          tweet: {
            user_id: Nuago::Schema::UUID.new, 
            text: Nuago::Schema::String.new(limit: 283)
          }
        }
      }
      
      def self.tweet_this(data)
        data = validate_schema!(data: data, schema: Schemas[:tweet_was_tweeted])
        new(Nuago.new_uuid).tweet_this(data)
      end

      def tweet_this(data)
        add_event :tweet_was_tweeted, data
        
        self
      end
    end
  end
end

require 'evented_twitter/aggregates/tweet/reducer'