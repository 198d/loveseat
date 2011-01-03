require 'test_helper'

class RestServerTest < Test::Unit::TestCase
  include Loveseat::Rest

  context '#initialize' do
    setup do
      host = 'localhost'
      port = 1234
      user = 'user'
      password = 'password'
      @server = Server.new(host, port, user, password)
    end
    should 'set the user' do
      assert_equal 'user', @server.user
    end
    should 'set the password' do
      assert_equal 'password', @server.password
    end
    should 'initialize the correct resource' do
      assert_equal Resource.new(Net::HTTP.new('localhost', 1234), '/', 'user', 'password'), @server
    end
  end

end
