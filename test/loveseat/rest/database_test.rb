require 'test_helper'

class RestDatabaseTest < Test::Unit::TestCase
  include Loveseat::Rest

  context '#initialize' do
    setup do
      @server = Server.new('localhost', 1234, 'user', 'password')
      @database = Database.new(@server, 'some_db')
    end
    should 'set the server' do
      assert_equal @server, @database.server
    end
    should 'initialize the correct resource' do
      resource = Resource.new(Net::HTTP.new('localhost', 1234), '/some_db/', 'user', 'password')
      assert_equal resource, @database
    end
  end
end
