require 'evented_twitter'
require 'minitest/autorun'
require 'minitest/focus'
require 'byebug'

module EventedTwitterFeatureTests
  
  class TestUserFollow < Minitest::Test
    # test('when I tweet something I can see it in my profile feed') do    

    def setup
      Nuago::EventStore.clear!
    end

    def data
      @user_id ||= SecureRandom.uuid
      @user_id_to_follow ||= SecureRandom.uuid

      {
        user_id: @user_id,
        user_id_to_follow: @user_id_to_follow
      }
    end

    def apply_command(command_name)
      EventedTwitter.apply_command(command_name: command_name, data: data)
    end

    def test_follow
      apply_command(:follow_user)
      
      then_event :user_was_followed do |event|
        assert_equal @user_id, event.data[:user_id]
        assert_equal @user_id_to_follow, event.data[:user_id_to_follow]
        assert_equal "#{@user_id}_#{@user_id_to_follow}", event.aggregate_id
      end
    end

    def test_follow_unfollow
      apply_command(:follow_user)
      apply_command(:unfollow_user)
      
      then_event :user_was_followed

      then_event :user_was_unfollowed do |event|
        assert_equal @user_id, event.data[:user_id]
        assert_equal @user_id_to_follow, event.data[:user_id_to_follow]
        assert_equal "#{@user_id}_#{@user_id_to_follow}", event.aggregate_id
      end
    end

    def test_unfollow
      apply_command(:unfollow_user)
      
      then_x_events 0, :user_was_unfollowed
    end

    def test_follow_follow_dont_duplicate_events
      apply_command(:follow_user)
      apply_command(:follow_user)
      
      then_x_events 1, :user_was_followed
    end

    def test_follow_unfollow_then_follow
      apply_command(:follow_user)
      apply_command(:unfollow_user)
      apply_command(:follow_user)
      
      then_x_events 2, :user_was_followed
      then_x_events 1, :user_was_unfollowed
    end

    protected

    def then_x_events(count, name)
      events = Nuago::EventStore.by_event_name(name)
      assert_equal count, events.size
    end

    def then_event(message_name, &blk)
      event = Nuago::EventStore.by_event_name(message_name).first
      assert event, "#{message_name} must be emitted"
      blk.call(event) if block_given?
    end
  end
end