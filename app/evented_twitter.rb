require 'nuago'
require 'evented_twitter/aggregates/tweet'
require 'evented_twitter/user_tweet'

module EventedTwitter

  # return persisted events
  def self.fetch_history(aggregate_type, aggregate_key)
    Nuago::EventStore.by_aggregate(type: aggregate_type, key: aggregate_key)
  end

  def self.fetch_entity(aggregate_type, aggregate_key)#, reducer: nil)
    reducer = "EventedTwitter::Aggregates::#{aggregate_type.capitalize}::Reducer".constantize

    events = fetch_history(aggregate_type, aggregate_key)
    state = reducer.reduce(events)
    
    return state
  end

  def self.reduce_entities_from_events(events)
    entities = {}
    grouped_events = events.group_by {|e| e.metadata[:aggregate_key]}
    grouped_events.map do |agg_key, events|
      aggregate_type = events.first.metadata[:aggregate_type]
      reducer = "EventedTwitter::Aggregates::#{aggregate_type.capitalize}::Reducer".constantize
      
      entities[agg_key] = {}
      entities[agg_key][:state] = reducer.reduce(events)
      entities[agg_key][:events] = events
    end
    entities
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
      raise NotImplementedError unless command[:command_name].to_sym == :tweet_this
      aggregate = EventedTwitter::Aggregates::Tweet.tweet_this(command[:data])
      aggregate.save(request_context: request_context)
    end
  end
end