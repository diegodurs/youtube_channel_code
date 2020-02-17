module EventedTwitter
  module Aggregates
    class UserFollow < Nuago::Aggregate
      class Reducer
        def self.reduce(events, state: nil)
          state = state || Nuago::Reducer.init_state
          state = Nuago::Reducer.reduce(events, state: state, fcts: reduce_fcts)
          state
        end

        def self.reduce_fcts
          {
            user_was_followed: -> (event, state) {
              state[:data] ||= event.data
              state[:following] = true
              state
            },
            user_was_unfollowed: -> (event, state) {
              state[:following] = false
              state
            }
          }
        end
      end
    end
  end
end