require 'nuago'
require 'aggregates/tweet'
require 'user_tweets'

module EventedTwitter

  # return persisted events
  # def self.fetch_history(aggregate_type, aggregate_key)
  #   Nuago::EventStore.by_aggregate(type: aggregate_type, key: aggregate_key)
  # end

  # def self.fetch_entity(aggregate_type, aggregate_key)#, reducer: nil)
  #   reducer = "EventedTwitter::Aggregates::#{aggregate_type.capitalize}::Reducer".constantize

  #   events = fetch_history(aggregate_type, aggregate_key)
  #   state = reducer.reduce(events)
    
  #   return state
  # end

  # ----------

  def self.make_query(query_name, query_params)
    raise NotImplementedError unless query_name.to_s == 'user_tweets'
    return UserTweets.for_user(query_params)

    # query_params[:includes][:tweet]
    # query_response[:entries].each do |entry|
    #   entry[:tweet] = fetch_entity(:tweet, entry[:tweet_id])
    # end
  end

  # --- CQS ---

  # command_hash = {
  #   command_name: '', 
  #   data: {}, 
  #   metadata: {}
  # }
  def self.apply_command(command_name, data = {})
    raise NotImplementedError unless command_name.to_s == 'tweet_this'
    tweet = Aggregates::Tweet.tweet_this(data)
    tweet.save
  end
end