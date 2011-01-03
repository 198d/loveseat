require 'test_helper'

class RestDocumentTest < Test::Unit::TestCase
  include Loveseat::Rest

  context "#initialize" do
    should 'setup the correct resource' do
      server = Server.new('localhost', 1234, 'user', 'password')
      database = Database.new(server,'some_db')
      document = Document.new(database, 'some_id')
      resource = Resource.new(Net::HTTP.new('localhost', 1234), '/some_db/some_id', 'user', 'password')
      assert_equal resource, document
    end
  end
end
