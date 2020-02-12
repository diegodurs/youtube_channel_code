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

  # ----------

  def self.handle_query(query)
    QueryHandler.handle(query)
  end

  module QueryHandler
    def self.handle(query)
      raise NotImplementedError unless query[:query_name] == 'user_tweets'
      UserTweets.for_user(query_params[:user_id], query_params[:pagination])
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
    CommandHandler.handle(command_hash)
  end

  module CommandHandler
    def self.apply(command)
      raise ArgumentError unless command.is_a?(Nuago::Command)
      public_send(command.name.underscore, command)
    end

    def self.tweet_this(command)
      
    end
  end
end