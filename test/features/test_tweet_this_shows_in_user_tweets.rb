require 'evented_twitter'
require 'minitest/autorun'
require 'byebug'

module EventedTwitterFeatureTests
  
  class TestTweetesModule < Minitest::Test
    # test('when I tweet something I can see it in my profile feed') do    

    def test_when_I_tweet_something_I_can_see_it_in_my_profile_feed
      # Given (nothing)
      # When (command)
      user_id = 1

      EventedTwitter.apply_command(
        command_name: :tweet_this, 
        data: {
          tweet: {
            user_id: user_id,
            original_text: "This is my first test Tweet"
          }
        }
      )
      
      # Then (state)
      tweets = EventedTwitter.handle_query(query_name: 'user_tweets', data: {user_id: user_id})

      puts tweets

      refute tweets.empty?, "one tweet exists"
      assert_equal tweets.first[:tweet][:original_text], "This is my first test Tweet"
    end
  end
  
end