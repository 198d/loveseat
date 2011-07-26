require 'rubygems'
require 'bundler'

Bundler.setup

require 'rspec'
require 'fakeweb'
require 'rr'
require 'loveseat'

FakeWeb.allow_net_connect = false

module MockHTTPResponses
  def mock_response(code, body = '{}')
    %Q|
HTTP/1.1 #{code} Message
Server: CouchDB/0.11.0 (Erlang OTP/R13B)
Pragma: no-cache
Expires: Fri, 01 Jan 1990 00:00:00 GMT
ETag: "A5MF2OY0S1A2JW0Y8XY1APATM"
Date: Mon, 03 Jan 2011 02:09:39 GMT
Content-Type: text/plain;charset=utf-8
Content-Length: #{body.size}
Cache-Control: must-revalidate, no-cache

#{body}
    |.strip
  end
end

RSpec.configure do |config|
  config.mock_with :rr 
  config.include MockHTTPResponses

  config.before(:each) do
    @server = Loveseat::Rest::Server.new('localhost', 5984)
    @database = Loveseat::Rest::Database.new(@server, 'loveseat_test')
  end

  config.after(:each) do
    FakeWeb.clean_registry
  end
end
