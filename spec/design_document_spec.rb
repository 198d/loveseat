require 'spec_helper'

describe Loveseat::DesignDocument do
  include Loveseat

  before :each do
    @klass = Class.new
    stub(@klass).name { 'TestClass' }
  end

  after :each do
    Document.registry.delete('TestClass')
  end

  describe '.setup' do
    it 'sets up the klass given using Document.setup, a special support object and forcing the klass to be setup as a singleton' do
      DesignDocument.setup(@klass) { }
      
      Document.registry[@klass.name].should be_singleton
      Document.registry[@klass.name].should be_an_instance_of(DesignDocument::Support)
    end
  end

  describe '.generate_id' do
    it 'generates a design document id based on the class given' do
      DesignDocument.generate_id(@klass).should == '_design/TestClass'
    end
  end

  describe '.view' do
    before :each do
      DesignDocument.setup(@klass) { }
      @rows = [
        { :id => '1',
          :key => '1',
          :value => '1' },
        { :id => '2',
          :key => '2',
          :value => '2' }
      ]
      FakeWeb.register_uri(:get,
        'http://localhost:5984/loveseat_test/_design/TestClass/_view/some_name',
        :response => mock_response(200, {:rows => @rows}.to_json))
    end

    it 'raises an exception when the view request does not return a status in the 200s' do
      FakeWeb.register_uri(:get,
        'http://localhost:5984/loveseat_test/_design/TestClass/_view/some_name',
        :response => mock_response(404))
     
      lambda do
        DesignDocument.view(@database, @klass, :some_name)
      end.should raise_error(Net::HTTPServerException)
    end

    it 'returns an array of the rows returned by the view' do
      result = DesignDocument.view(@database, @klass, :some_name)
      
      result.should be_an_instance_of(Array)
      result.size.should == 2
    end

    it 'returns the rows as ViewRow objects with all the correct values populated' do
      result = DesignDocument.view(@database, @klass, :some_name)
      
      result.each_with_index do |r,i|
        value = (i + 1).to_s

        r.should be_an_instance_of(DesignDocument::ViewRow)
        r.id.should == value
        r.key.should == value
        r.value.should == value
      end
    end

    it 'returns only the view rows that match a set of keys by posting a list of them to the database' do
      FakeWeb.register_uri(:post,
        'http://localhost:5984/loveseat_test/_design/TestClass/_view/some_name',
        :response => mock_response(200, {:rows => @rows}.to_json))
      keys = ['1234', '2234']

      DesignDocument.view(@database, @klass, :some_name, :keys => keys).should_not be_empty
      FakeWeb.last_request.body.should == {:keys => keys}.to_json
    end

    it 'passes options as query string parameters to the view request excluding the :keys option' do
      FakeWeb.register_uri(:post,
        'http://localhost:5984/loveseat_test/_design/TestClass/_view/some_name?param=value',
        :response => mock_response(200, {:rows => @rows}.to_json))
      keys = ['1234', '2234']

      DesignDocument.view(@database, @klass, :some_name, :param => 'value', :keys => keys).should_not be_empty
    end
  end
end
