module EventedTwitter
  module Aggregates
    module Tweet
      class Reducer
        def self.reduce(events)
          state = Nuago::Reducer.init_state
          state = Nuago::Reducer.reduce(state: state, fcts: reduce_fcts, events: events)
          state
        end

        def self.reduce_fcts
          {
            tweet_was_tweeted: -> (event, state) {
              event.payload.each do |k, val|
                state[k] = val
              end
            }
          }
        end
      end
    end
  end
end