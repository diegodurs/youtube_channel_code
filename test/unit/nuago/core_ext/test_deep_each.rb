module NuagoTests
  module CoreExt
    class TestDeepEachAndFetch < Minitest::Test
      def array_with_hashes
        [{joe: "hi"}, {bar: "ho"}, 'lol']
      end

      def array_inside_hash
        {entries: [{bar: "hi"}, {bar: "ho"}], limit: 1}
      end

      def array_multi_deep
        {foo: {bar: [{toe: "deep", things: ["Ho my"]}]}, joe: "Hello"}
      end

      def assert_observed_keys(expected_keys, data)
        observed_keys = []

        data.deep_each do |k, _|
          observed_keys << k
        end
        
        assert_equal expected_keys, observed_keys
      end
      
      def test_array_with_hashes
        assert_observed_keys(['0.joe', '1.bar', '2'], array_with_hashes)
      end

      def test_array_inside_hash
        assert_observed_keys(
          ['entries.0.bar', 'entries.1.bar', 'limit'], array_inside_hash)
      end

      def test_multi_deep_each
        assert_observed_keys(
          ['foo.bar.0.toe', 'foo.bar.0.things.0', 'joe'], array_multi_deep)
      end

      # Fetch

      def test_fetch_with_array_with_hashes
        assert_equal 'hi', array_with_hashes.deep_fetch('0.joe')
        assert_equal 'ho', array_with_hashes.deep_fetch('1.bar')
        assert_equal 'lol', array_with_hashes.deep_fetch('2')
      end

      def test_fetch_with_array_return_whole_hash
        assert_equal array_with_hashes[1], array_with_hashes.deep_fetch('1')
      end

      def test_fetch_with_nil_when_void_path
        assert_nil array_with_hashes.deep_fetch('0.bar')
        assert_nil array_with_hashes.deep_fetch('1.joe')
        assert_nil array_with_hashes.deep_fetch('4')
      end

      def test_fetch_with_array_inside_hash
        assert_equal 'hi', array_inside_hash.deep_fetch('entries.0.bar')
        assert_equal 'ho', array_inside_hash.deep_fetch('entries.1.bar')
        assert_equal 1, array_inside_hash.deep_fetch('limit')
      end

      def test_fetch_with_multi_deep
        assert_equal 'deep', array_multi_deep.deep_fetch('foo.bar.0.toe')
        assert_equal 'Ho my', array_multi_deep.deep_fetch('foo.bar.0.things.0')
        assert_equal 'Hello', array_multi_deep.deep_fetch('joe')
      end

      # Assign

      def test_assign_with_array_inside_hash
        assert_equal 'hi', array_inside_hash.deep_fetch('entries.0.bar')
        new_data = array_inside_hash.deep_assign('entries.0.bar', 'bye')
        assert_equal 'bye', new_data.deep_fetch('entries.0.bar')
      end
    end
  end
end
