require 'test_helper'

class RestResourceTest < Test::Unit::TestCase
  include Loveseat::Rest
  
  context "#initialize" do
    should "set the connection" do
      connection = Net::HTTP.new('host', 1234)
      resource = Resource.new(connection)
      assert_equal connection, resource.connection
    end

    should "set the uri object" do
      connection = Net::HTTP.new('host', 1234)
      resource = Resource.new(connection, '/some/path')
      
      assert_equal URI.parse('http://host:1234/some/path'), resource.uri
    end

    should "set the uri object with a username" do
      connection = Net::HTTP.new('host', 1234)
      resource = Resource.new(connection, '/', 'user')
      
      assert_equal URI.parse('http://user@host:1234/'), resource.uri
    end
    
    should "set the uri object with a username and password" do
      connection = Net::HTTP.new('host', 1234)
      resource = Resource.new(connection, '/', 'user', 'password')
      
      assert_equal URI.parse('http://user:password@host:1234/'), resource.uri
    end
  end

  context "#==" do
    should 'return true if both uri and connection are the same' do
      r1 = Resource.new(Net::HTTP.new('host', 1234), '/some/path', 'user', 'password')
      r2 = Resource.new(Net::HTTP.new('host', 1234), '/some/path', 'user', 'password')
      assert r1 == r2
    end
  end

  # TODO: Dry this up.
  # Tests HTTP Methods
  # All tests are identical except for the method being used
  # Some are fragile and really only fail when FakeWeb raises
  context "#delete" do
    setup do
      @resource = Resource.new(
        Net::HTTP.new('localhost', 1234),
        '/some/path' )
    end

    teardown do
      FakeWeb.clean_registry
    end

    should 'send a request to the resource and return an array with the response and the body parsed as json' do
      
      FakeWeb.register_uri(:delete, 'http://localhost:1234/some/path', {:response => http_response})
      expected_body = {"couchdb"=>"Welcome","version"=>"0.11.0"}
      response, body = @resource.delete

      assert_equal expected_body, body
      assert_kind_of Net::HTTPResponse, response
    end 

    should 'send a request with the content type  application/json' do
      FakeWeb.register_uri(:delete, 'http://localhost:1234/some/path', {:response => http_response})
      @resource.delete
      assert_equal 'application/json', FakeWeb.last_request['Content-Type']
    end

    should 'to_json the request body if it is not a string' do
      FakeWeb.register_uri(:delete, 'http://localhost:1234/some/path', {:response => http_response})
      @resource.delete({:body => [1,2,3]})
      assert_equal '[1,2,3]', FakeWeb.last_request.body
    end
    
    should 'use authentication information if it is available' do
      FakeWeb.register_uri(:delete, 'http://user:password@localhost:1234/some/path', :response => http_response)
      resource = Resource.new(
        Net::HTTP.new('localhost', 1234),
        '/some/path',
        'user',
        'password' )
      response, body = resource.delete

      assert response
    end

    should 'send a request to the resource with a request body' do
      FakeWeb.register_uri(:delete, 'http://localhost:1234/some/path', {:response => http_response})
      request_body = 'some body' 
      response, body = @resource.delete(request_body)

      assert_equal request_body, FakeWeb.last_request.body
    end 

    should 'send a request to the resource with a request body and a query string' do
      FakeWeb.register_uri(:delete, 'http://localhost:1234/some/path?param=value', {:response => http_response})
      request_body = 'some body' 
      response, body = @resource.delete({:query => {:param => 'value'}, :body => request_body})

      assert_equal request_body, FakeWeb.last_request.body
    end 
  end

  context "#post" do
    setup do
      @resource = Resource.new(
        Net::HTTP.new('localhost', 1234),
        '/some/path' )
    end

    teardown do
      FakeWeb.clean_registry
    end

    should 'send a request to the resource and return an array with the response and the body parsed as json' do
      
      FakeWeb.register_uri(:post, 'http://localhost:1234/some/path', {:response => http_response})
      expected_body = {"couchdb"=>"Welcome","version"=>"0.11.0"}
      response, body = @resource.post

      assert_equal expected_body, body
      assert_kind_of Net::HTTPResponse, response
    end 

    should 'send a request with the content type  application/json' do
      FakeWeb.register_uri(:post, 'http://localhost:1234/some/path', {:response => http_response})
      @resource.post
      assert_equal 'application/json', FakeWeb.last_request['Content-Type']
    end

    should 'to_json the request body if it is not a string' do
      FakeWeb.register_uri(:post, 'http://localhost:1234/some/path', {:response => http_response})
      @resource.post({:body => [1,2,3]})
      assert_equal '[1,2,3]', FakeWeb.last_request.body
    end
    
    should 'use authentication information if it is available' do
      FakeWeb.register_uri(:post, 'http://user:password@localhost:1234/some/path', :response => http_response)
      resource = Resource.new(
        Net::HTTP.new('localhost', 1234),
        '/some/path',
        'user',
        'password' )
      response, body = resource.post

      assert response
    end

    should 'send a request to the resource with a request body' do
      FakeWeb.register_uri(:post, 'http://localhost:1234/some/path', {:response => http_response})
      request_body = 'some body' 
      response, body = @resource.post(request_body)

      assert_equal request_body, FakeWeb.last_request.body
    end 

    should 'send a request to the resource with a request body and a query string' do
      FakeWeb.register_uri(:post, 'http://localhost:1234/some/path?param=value', {:response => http_response})
      request_body = 'some body' 
      response, body = @resource.post({:query => {:param => 'value'}, :body => request_body})

      assert_equal request_body, FakeWeb.last_request.body
    end 
  end

  context "#get" do
    setup do
      @resource = Resource.new(
        Net::HTTP.new('localhost', 1234),
        '/some/path' )
    end

    teardown do
      FakeWeb.clean_registry
    end

    should 'send a request to the resource and return an array with the response and the body parsed as json' do
      
      FakeWeb.register_uri(:get, 'http://localhost:1234/some/path', {:response => http_response})
      expected_body = {"couchdb"=>"Welcome","version"=>"0.11.0"}
      response, body = @resource.get

      assert_equal expected_body, body
      assert_kind_of Net::HTTPResponse, response
    end 

    should 'send a request with the content type  application/json' do
      FakeWeb.register_uri(:get, 'http://localhost:1234/some/path', {:response => http_response})
      @resource.get
      assert_equal 'application/json', FakeWeb.last_request['Content-Type']
    end

    should 'to_json the request body if it is not a string' do
      FakeWeb.register_uri(:get, 'http://localhost:1234/some/path', {:response => http_response})
      @resource.get({:body => [1,2,3]})
      assert_equal '[1,2,3]', FakeWeb.last_request.body
    end
    
    should 'use authentication information if it is available' do
      FakeWeb.register_uri(:get, 'http://user:password@localhost:1234/some/path', :response => http_response)
      resource = Resource.new(
        Net::HTTP.new('localhost', 1234),
        '/some/path',
        'user',
        'password' )
      response, body = resource.get

      assert response
    end

    should 'send a request to the resource with a request body' do
      FakeWeb.register_uri(:get, 'http://localhost:1234/some/path', {:response => http_response})
      request_body = 'some body' 
      response, body = @resource.get(request_body)

      assert_equal request_body, FakeWeb.last_request.body
    end 

    should 'send a request to the resource with a request body and a query string' do
      FakeWeb.register_uri(:get, 'http://localhost:1234/some/path?param=value', {:response => http_response})
      request_body = 'some body' 
      response, body = @resource.get({:query => {:param => 'value'}, :body => request_body})

      assert_equal request_body, FakeWeb.last_request.body
    end 
  end

  context "#put" do
    setup do
      @resource = Resource.new(
        Net::HTTP.new('localhost', 1234),
        '/some/path' )
    end

    teardown do
      FakeWeb.clean_registry
    end

    should 'send a request to the resource and return an array with the response and the body parsed as json' do
      
      FakeWeb.register_uri(:put, 'http://localhost:1234/some/path', {:response => http_response})
      expected_body = {"couchdb"=>"Welcome","version"=>"0.11.0"}
      response, body = @resource.put

      assert_equal expected_body, body
      assert_kind_of Net::HTTPResponse, response
    end 

    should 'send a request with the content type  application/json' do
      FakeWeb.register_uri(:put, 'http://localhost:1234/some/path', {:response => http_response})
      @resource.put
      assert_equal 'application/json', FakeWeb.last_request['Content-Type']
    end

    should 'to_json the request body if it is not a string' do
      FakeWeb.register_uri(:put, 'http://localhost:1234/some/path', {:response => http_response})
      @resource.put({:body => [1,2,3]})
      assert_equal '[1,2,3]', FakeWeb.last_request.body
    end
    
    should 'use authentication information if it is available' do
      FakeWeb.register_uri(:put, 'http://user:password@localhost:1234/some/path', :response => http_response)
      resource = Resource.new(
        Net::HTTP.new('localhost', 1234),
        '/some/path',
        'user',
        'password' )
      response, body = resource.put

      assert response
    end

    should 'send a request to the resource with a request body' do
      FakeWeb.register_uri(:put, 'http://localhost:1234/some/path', {:response => http_response})
      request_body = 'some body' 
      response, body = @resource.put(request_body)

      assert_equal request_body, FakeWeb.last_request.body
    end 

    should 'send a request to the resource with a request body and a query string' do
      FakeWeb.register_uri(:put, 'http://localhost:1234/some/path?param=value', {:response => http_response})
      request_body = 'some body' 
      response, body = @resource.put({:query => {:param => 'value'}, :body => request_body})

      assert_equal request_body, FakeWeb.last_request.body
    end 
  end

  private
    def http_response
      <<-RESPONSE
HTTP/1.1 200 OK
Server: CouchDB/0.11.0 (Erlang OTP/R13B)
Date: Fri, 31 Dec 2010 01:15:15 GMT
Content-Type: text/plain;charset=utf-8
Content-Length: 41
Cache-Control: must-revalidate

{"couchdb":"Welcome","version":"0.11.0"}
      RESPONSE
    end
end
