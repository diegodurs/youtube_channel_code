module EventedTwitter
  module Aggregates
    class Tweet
      class Reducer
        def self.reduce(events, state: nil)
          state = state || Nuago::Reducer.init_state
          state = Nuago::Reducer.reduce(events, state: state, fcts: reduce_fcts)
          state
        end

        def self.reduce_fcts
          {
            tweet_was_tweeted: -> (event, state) {
              state[:tweet] = event.data[:tweet]
              state
            }
          }
        end
      end
    end
  end
end