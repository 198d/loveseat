require 'test_helper'

class HashTest < Test::Unit::TestCase
  context '#to_query' do
    should "return a key value pair for a query string" do
      query_hash = {
        :key => 'value'
      }
      assert_equal 'key=value', query_hash.to_query
    end

    should "return ampersand seperated key values for a query string" do
      query_hash = {
        :key1 => 'value1',
        :key2 => 'value2'
      }

      assert_match /(key1|key2)=(value1|value2)&(key1|key2)=(value1|value2)/, query_hash.to_query
    end

    should "return uri escaped components" do
      query_hash = {
        :key => 'value'
      }
      
      stub(URI) do
        escape('key').returns('escapedkey')
        escape('value').returns('escapedvalue')
      end
      
      assert_equal "escapedkey=escapedvalue", query_hash.to_query
    end
  end
end
