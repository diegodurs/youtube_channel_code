require 'nuago'
require 'evented_twitter/aggregates/tweet'
require 'evented_twitter/user_tweet'
require 'evented_twitter/aggregates/user_follow'

module EventedTwitter

  # return persisted events
  def self.fetch_history(aggregate_type, aggregate_id)
    Nuago::EventStore.by_aggregate(type: aggregate_type, key: aggregate_id)
  end

  def self.fetch_entity(aggregate_type, aggregate_id)#, reducer: nil)
    reducer = reducer_for(aggregate_type)
    
    events = fetch_history(aggregate_type, aggregate_id)
    state = reducer.reduce(events)
    
    return state
  end

  def self.reducer_for(aggregate_type)
    "EventedTwitter::Aggregates::#{aggregate_type}::Reducer".constantize
  end

  def self.reduce_entities_from_events(events)
    entities = {}
    grouped_events = events.group_by {|e| e.metadata[:aggregate_id]}
    grouped_events.map do |agg_key, events|
      aggregate_type = events.first.metadata[:aggregate_type]
      reducer = reducer_for(aggregate_type)
      
      entities[agg_key] = {}
      entities[agg_key][:state] = reducer.reduce(events)
      entities[agg_key][:events] = events
    end
    entities
  end

  def self.reduce_entity_from_events(events)
    aggregate_type = events.first.metadata[:aggregate_type]
    reducer = reducer_for(aggregate_type)
    reducer.reduce(events)
  end

  # ----------

  def self.handle_query(query)
    QueryHandler.handle(query)
  end

  module QueryHandler
    def self.handle(query)
      raise NotImplementedError unless query[:query_name] == 'user_tweets'
      UserTweet.for_user(query[:data])
    end
  end

  # --- CQS ---

  # command_hash = {
  #   command_name: '', 
  #   payload: {}, 
  #   session: {
  #     current_user_id: '', 
  #     session_id: ''}, 
  #   request: {}
  # }
  def self.apply_command(command_hash)
    CommandHandler.apply(command_hash)
  end

  module CommandHandler
    def self.apply(command, request_context: {})
      case command[:command_name]
      when :tweet_this
        aggregate = EventedTwitter::Aggregates::Tweet.tweet_this(command[:data])
        aggregate.save(request_context: request_context)
      when :follow_user
        aggregate = EventedTwitter::Aggregates::UserFollow.follow(command[:data])
        aggregate.save(request_context: request_context)
      when :unfollow_user
        aggregate = EventedTwitter::Aggregates::UserFollow.unfollow(command[:data])
        aggregate.save(request_context: request_context)
      else
        raise NotImplementedError
      end
    end
  end
end