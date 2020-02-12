require 'minitest/autorun'
require 'evented_twitter'

module EventedTwitterFeatureTests
  
  class TestTweetesModule < Minitest::Test
    # test('when I tweet something I can see it in my profile feed') do    

    def test_when_I_tweet_something_I_can_see_it_in_my_profile_feed
      # Given (nothing)
      # When (command)
      user_id = 123

      EventedTwitter.apply_command(:tweet_this, {
        tweet: {
          user_id: user_id,
          text: "This is my first Tweet"
        }
      })
      
      # Then (state)
      tweets = EventedTwitter.make_query(:user_tweets, {user_id: 123})
      refute tweets.empty?, "one tweet exists"
      pp tweets
      assert_equal tweets.first[:text], "This is my first Tweet"
    end
  end
end