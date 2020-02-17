require 'evented_twitter/aggregates/user_follow/reducer'

module EventedTwitter
  module Aggregates
    class UserFollow < Nuago::Aggregate

      Schemas = {
        user_was_followed: {
          user_id: Nuago::Schema::UUID.new(null: false), 
          user_id_to_follow: Nuago::Schema::UUID.new(null: false)
        }
      }
      Schemas[:user_was_unfollowed] = Schemas[:user_was_followed]

      def self.build_aggregate_id(data)
        "#{data[:user_id]}_#{data[:user_id_to_follow]}"
      end
      
      def self.follow(data)
        data = validate_schema!(data: data, schema: Schemas[:user_was_followed])
        id = build_aggregate_id(data)

        load_aggregate(id).follow(data)
      end

      def self.unfollow(data)
        data = validate_schema!(data: data, schema: Schemas[:user_was_unfollowed])
        id = build_aggregate_id(data)

        load_aggregate(id).unfollow(data)
      end

      def follow(data)
        add_event :user_was_followed, data unless state[:following]
        
        self
      end

      def unfollow(data)
        add_event :user_was_unfollowed, data if state[:following]
        
        self
      end
    end
  end
end