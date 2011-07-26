require 'spec_helper'

describe Loveseat::Document do
  include Loveseat
  before :each do 
    @klass = Class.new
    stub(@klass).name { 'TestClass' }
  end
 
  after :each do
    Document.registry.delete('TestClass')
  end
  
  shared_examples_for "a method that raises errors after bad http requests" do
    it 'raises an appropriate exception when the response is not in the 200s' do
      FakeWeb.register_uri(@uri.first, @uri.last,
        :response => mock_response(404))  
      
      Document.setup(@klass) { }

      lambda do
        Document.send(*@method)
      end.should raise_error(Net::HTTPServerException)
    end
  end
  
  describe '.add_resolver' do
    it 'adds an item to the regexp' do
      Document.add_resolver(//)
      //.should == Document.class_variable_get(:"@@resolvers").pop
    end
  end

  describe '.next_id' do
    before :each do
      @uuid_response = mock_response(200, '{"uuids":["ec447d270d8bd1631761d87e55000200"]}')
    end

    after :each do
      FakeWeb.clean_registry
      Loveseat::Document.class_variable_set(:@@uuids, [])
    end
    
    it 'returns a new uuid based on a class constant' do
      FakeWeb.register_uri(:get, 'http://localhost:1234/_uuids?count=100', :response => @uuid_response)

      klass = Class.new
      stub(klass).name { 'OurClass' }
      server = Rest::Server.new('localhost', 1234)
      'OurClass:ec447d270d8bd1631761d87e55000200'.should == Document.next_id(server, klass)
    end

    it 'caches and uses multiple uuids returned from couch' do
        
      uuid_response = mock_response(200, '{"uuids":["6b9972ccf7644b95c574693f24006f68","6b9972ccf7644b95c574693f24007c92"]}')
      FakeWeb.register_uri(:get, 'http://localhost:1234/_uuids?count=100', :response => uuid_response)
      
      klass = Class.new
      stub(klass).name { 'OurClass' }
      server = Rest::Server.new('localhost', 1234)

      Loveseat::Document.next_id(server, klass)
      'OurClass:6b9972ccf7644b95c574693f24007c92'.should == Loveseat::Document.next_id(server, klass)
    end
    
  end

  describe '.resolve' do
    it 'returns the first submatch from the first regexp in the registry that matches the input' do
      'OurClass'.should == Document.resolve('OurClass:asd123')
    end
  end

  describe '.setup' do
    it 'adds a new instance of Document::Support with the supplied options to the registry' do
      support = Document::Support.new(@klass)
      stub.proxy(Document::Support).new(@klass, {}) do |s|
        support
      end
      Document.setup(@klass) { }
      support.should ==  Document.registry['TestClass']
    end
    it 'override the new instance of Document::Support with a provided instance' do
      support = Document::Support.new(@klass)
      Document.setup(@klass, :support => support) { }
      support.should == Document.registry['TestClass']
    end
    pending 'instance_evals the block given on the Document::DSL object' do
      support = Document::Support.new(@klass)
      dsl = Document::DSL.new(support)
      stub(dsl).some_method
      stub.proxy(support).dsl { dsl }
      stub.proxy(Document::Support).new(@klass, {}) do |s|
        support
      end
      Document.setup(@klass, {}) { some_method } 

      dsl.should have_received(:some_method)
    end
    it 'returns the Document::Support instance' do
      support = Document::Support.new(@klass)
      stub.proxy(Document::Support).new(@klass, {}) do |s|
        support
      end
      support.should == Document.setup(@klass) { }
    end
  end

  describe '.put' do
    before :each do 
      Document.setup(@klass) { }
      stub(Document).next_id { 'TestClass:12345' }
      
      @uri = [:put, 'http://localhost:5984/loveseat_test/TestClass:12345']
      @method = [:put, @database, @klass.new]
      
      FakeWeb.register_uri(:put, @uri.last, 
        :response => mock_response(201, '{"ok": true, "id": "TestClass:1234", "rev": "946B7D1C"}'))
    end

    it_should_behave_like 'a method that raises errors after bad http requests'

    it 'raises NotRegisteredError if the class of the object has not been setup' do
      lambda do
        Document.put(@database, Object.new)
      end.should raise_error(Document::NotRegisteredError)
    end

    it 'raises AbstractDocumentError if the class of the object has been setup as an abstract document' do
      object = @klass.new
      stub(Document.registry['TestClass']).abstract? { true }
      lambda do
        Document.put(@database, object)
      end.should raise_error(Document::AbstractDocumentError)
    end

    it 'uses the next uuid and the class name as the _id if it is not set' do
      object = @klass.new
      stub(Document).next_id { 'TestClass:12345' }
      Document.put(@database, object)
      
      object._id.should == 'TestClass:12345'
    end
    
    it 'returns the object given' do
      object = @klass.new
      stub(Document).next_id { 'TestClass:12345' }
      returned = Document.put(@database, object)

      returned.should == object
    end

    it 'stubs attachment data after a successful put' do
      object = @klass.new
      object._attachments = {'some_file.txt' => {'data' => 'abcde'}}
      stub(Document).next_id { 'TestClass:12345' }
      Document.put(@database, object)
      
      object._attachments.should == {'some_file.txt' => {'stub' => true, 'length' => 5}}
    end

    it 'sets the _rev value of the object based on what is returned from couch' do
      object = @klass.new
      object._attachments = {'some_file.txt' => {'data' => 'abcde'}}
      stub(Document).next_id { 'TestClass:12345' }
      Document.put(@database, object)

      object._rev.should == '946B7D1C'
    end
  end
  
  describe '.get' do
    before :each do
      Document.setup(@klass) { integer :number }      
      
      FakeWeb.register_uri(:get, 'http://localhost:5984/loveseat_test/TestClass:12345', :response => mock_response(200,'{"_id":"TestClass:12345", "_rev":"12345", "number": 9}')) 
    end
    it 'raises an appropriate exception when the response is not in the 200s' do
      FakeWeb.register_uri(:get, 'http://localhost:5984/loveseat_test/some_id',
        :response => mock_response(404))  
      object = @klass.new
      
      lambda do
        Document.get(@database, 'some_id')
      end.should raise_error(Net::HTTPServerException)
    end

    it 'returns an object of the appropriate type by resolving the class from the id' do 
      object = Document.get(@database, 'TestClass:12345')
      object.should be_an_instance_of(@klass)
    end

    it 'returns an object that has the correct attributes populated by the response' do
      object = Document.get(@database, 'TestClass:12345')
      object._id.should == 'TestClass:12345'
      object._rev.should == '12345'
      object.number.should == 9
    end
  end


  describe '.all' do
    before :each do
      @uri = [:get, /_all_docs/]
      @method = [:all, @database, @klass]
    end
    it_should_behave_like 'a method that raises errors after bad http requests'

    it 'raises a Document::NotRegisteredError if the klass passed in is not registered' do
      lambda do
        Document.all(@database, @klass)
      end.should raise_error(Document::NotRegisteredError)
    end

    it 'retrieves all documents for the given klass from the database and returns objects of type klass' do
      Document.setup(@klass) { }
      body = '{"rows": [ {"doc": {"_id":"TestClass:12345"}}, {"doc": {"_id": "TestClass:22345"}} ]}'
    
      FakeWeb.register_uri(:get, 
        "http://localhost:5984/loveseat_test/_all_docs?startkey=#{URI.escape("TestClass:".to_json)}&endkey=#{URI.escape("TestClass:\ufff0".to_json)}&include_docs=true",
        :response => mock_response(200, body))

      documents = Document.all(@database, @klass)
      documents.size.should == 2
      documents.each { |d| d.should be_an_instance_of(@klass) }
    end
  end
  
  describe '.attach' do
    before :each do
      @stream = StringIO.new('Some string.')
      stub(@stream).path { '/some/path/file.jpg' }
      Document.setup(@klass) { }

      @object = @klass.new
      @object._id = 'TestClass:12345'
      @object._rev = '12345'

      @uri = [:put, /loveseat_test\/TestClass:12345\/file\.jpg/]
      @method = [:attach, @database, @object, @stream, :force => true]
    end
    it_should_behave_like 'a method that raises errors after bad http requests'

    describe 'with the :force option set' do
      it 'immediately puts the attachment into the database with the correct content_type and data' do
        FakeWeb.register_uri(:put, 
          'http://localhost:5984/loveseat_test/TestClass:12345/file.jpg?rev=12345',
          :response => mock_response(201, '{"ok":true}'))

        Document.attach(@database, @object, @stream, :force => true).should be_true
        
        last_request = FakeWeb.last_request
        last_request['Content-Type'].should == 'image/jpeg'
        last_request.body.should == 'Some string.'
      end

      it 'allows specifying a different name' do
        FakeWeb.register_uri(:put, 
          'http://localhost:5984/loveseat_test/TestClass:12345/different_file.jpg?rev=12345',
          :response => mock_response(201, '{"ok":true}'))
        
        Document.attach(@database, @object, @stream, :force => true,
          :name => 'different_file.jpg').should be_true
      end

      it 'allows specifying a different content_type' do  
        FakeWeb.register_uri(:put, 
          'http://localhost:5984/loveseat_test/TestClass:12345/file.jpg?rev=12345',
          :response => mock_response(201, '{"ok":true}'))

        Document.attach(@database, @object, @stream, :force => true,
          :content_type => 'text/plain')
        
        FakeWeb.last_request['Content-Type'].should == 'text/plain'
      end
    end

    describe 'without the :force option set' do
      it 'base64 encodes the file contents and creates a new entry in the _attachments hash on the object with the content_type and data' do
        Document.attach(@database, @object, @stream).should be_true
        
        @object._attachments['file.jpg'].should == { 'content_type' => 'image/jpeg', 'data' => ['Some string.'].pack('m') }  
      end

      it 'allows specifying a different name' do
        Document.attach(@database, @object, @stream, :name => 'different_file.jpg')
        
        @object._attachments['different_file.jpg'].should_not be_nil
      end
      
      it 'allows specifying a different content_type' do  
        Document.attach(@database, @object, @stream,
          :content_type => 'text/plain')
        
        @object._attachments['file.jpg']['content_type'].should == 'text/plain'
      end
    end
  end
  
  describe '.delete' do
    before :each do
      Document.setup(@klass) { }
      @object = @klass.new
      @object._id = 'TestClass:12345'
      @object._rev = '12345'

      @uri = [:delete, /TestClass:12345/]
      @method = [:delete, @database, @object]
    end
    it_should_behave_like 'a method that raises errors after bad http requests'

    it 'deletes the document associated with the object from the database' do
      FakeWeb.register_uri(:delete,
        'http://localhost:5984/loveseat_test/TestClass:12345?rev=12345',
        :response => mock_response(200, '{"ok":true, "rev":"22345"}'))

      Document.delete(@database,@object).should be_true
    end

    it 'sets the new revision on the object' do
      FakeWeb.register_uri(:delete,
        'http://localhost:5984/loveseat_test/TestClass:12345?rev=12345',
        :response => mock_response(200, '{"ok":true, "rev":"22345"}'))

      Document.delete(@database,@object).should be_true
      @object._rev.should == '22345'
    end
  end
end
