require 'test_helper'

class HashTest < Test::Unit::TestCase
  def test_to_query_returns_a_key_value_pair_for_a_query_string
    query_hash = {
      :key => 'value'
    }
    assert_equal 'key=value', query_hash.to_query
  end

  def test_to_query_returns_ampersand_seperated_key_values_for_a_query_string
    query_hash = {
      :key1 => 'value1',
      :key2 => 'value2'
    }

    assert_match /(key1|key2)=(value1|value2)&(key1|key2)=(value1|value2)/, query_hash.to_query
  end

  def test_to_query_returns_uri_escaped_components
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
