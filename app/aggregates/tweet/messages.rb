module EventedTwitter
  module Aggregates
    module Tweet
      class TweetWasTweeted < Nuago::Event
        # must_validate 'tweet text must be non empty' do
        #   tweet.tweet_txt.size > 0
        # end

        # must_validate 'tweet text must shorter than 288' do
        #   tweet.tweet_txt.size <= 288
        # end

        # must_validate 'user must be present' do
        #   tweet.user_id.present?
        # end

        # aggregate_key 'tweet.tweet_id'

        # schema do
        #   tweet: EventedTwitter::Aggregates::Tweet::Schemas::Tweet
        # end
      end

      # class TweetThis < Nuago::Command
      #   emits_event TweetWasTweeted #, :same_validations, :same_schema
      # end
    end
  end
end