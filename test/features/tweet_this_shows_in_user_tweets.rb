require 'minitest/autorun'

module EventedTwitterFeatureTests
  
  class TestTweetesModule < Minitest::Test
    # test('when I tweet something I can see it in my profile feed') do    

    def test_when_I_tweet_something_I_can_see_it_in_my_profile_feed
      # Given (nothing)
      # When (command)
      user_id = 1
      command = Tweetes::Commands::TweetThis.new(
          tweet: {
            user_id: user_id,
            original_text: "This is my first test Tweet"
          }
        )

      Tweetes.apply_command(command)
      
      # Then (state)
      tweets = Tweetes.get_user_tweets(user_id)
      refute tweets.empty?, "one tweet exists"
      assert_equal tweets.first[:original_text], "This is my first test Tweet"
    end
  end
  
end