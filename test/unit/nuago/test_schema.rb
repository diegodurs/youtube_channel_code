require 'nuago/schema'
require 'minitest/autorun'
require "minitest/focus"
require 'byebug'
require 'securerandom'

module NuagoTests

  class TestSchema 

    class TestCleanUnknownKeys < Minitest::Test
      def schema
        {
          tweet: {
            user_id: Nuago::Schema::UUID.new, 
            text: Nuago::Schema::String.new(limit: 283)
          }
        }
      end
      
      def test_no_unknown_keys
        data = {
          tweet: {
            user_id: SecureRandom.uuid,
            text: "Hello man"
          }
        }
        
        new_data = Nuago::Schema.clean_unknwon_keys(data: data, schema: schema)
        
        assert_equal new_data, data
      end

      def test_filtered_unknown_keys
        data = {
          tweet: {
            user_id: SecureRandom.uuid,
            text: "Hello man",
            foo: "should not exists"
          },
          hack_this: "nope"
        }

        refute_nil data.deep_fetch('tweet.foo')
        refute_nil data.deep_fetch('hack_this')
        
        new_data = Nuago::Schema.clean_unknwon_keys(data: data, schema: schema)
        
        assert_nil new_data.deep_fetch('tweet.foor')
        assert_nil new_data.deep_fetch('hack_this')
      end

    end
    class TestValidatePresenceAndType < Minitest::Test
      def schema
        {
          tweet: {
            user_id: Nuago::Schema::UUID.new, 
            text: Nuago::Schema::String.new(limit: 283)
          }
        }
      end
     
      def test_green_behavior
        data = {
          tweet: {
            user_id: SecureRandom.uuid,
            text: "Hello man"
          }
        }
        
        errors = Nuago::Schema.validate_presence_and_type(data: data, schema: schema)
        
        # Then
        assert_predicate errors, :empty?
      end

      def test_missing_key
        data = {
          tweet: {
            user_id: SecureRandom.uuid,
          }
        }
        
        errors = Nuago::Schema.validate_presence_and_type(data: data, schema: schema)
        
        # Then
        refute_predicate errors, :empty?
        assert_equal 1, errors.size

        assert_equal errors.first.first, 'tweet.text'
        assert_equal errors.first.last, 'must be present'
      end

      def test_invalid_datatype
        data = {
          tweet: {
            user_id: "not a valid uuid",
            text: "Hello World"
          }
        }
        
        errors = Nuago::Schema.validate_presence_and_type(data: data, schema: schema)
        
        # Then
        refute_predicate errors, :empty?
        assert_equal 1, errors.size

        assert_equal errors.first.first, 'tweet.user_id'
      end
    end
  end
end