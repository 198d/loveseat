require 'test_helper'

class RestDesignDocumentTest < Test::Unit::TestCase
  include Loveseat::Rest

  context "#initialize" do
    should 'setup the appropriate resource' do
      server = Server.new('localhost', 1234, 'user', 'password')
      database = Database.new(server,'some_db')
      design_document = DesignDocument.new(database, 'design_doc')
      document = Document.new(database, '_design/design_doc')
      assert_equal document, design_document
    end
  end
end
