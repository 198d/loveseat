require 'net/http'
require 'uri'
require 'json'

module Rest
  class Resource
    attr_reader :connection

    def initialize(connection, path = '/', username=nil, password=nil)
      @connection = connection
      uri = [ 'http://',
              [connection.address,
               connection.port].join(':'), 
              path ].join
      @uri = URI.parse(uri)
      @username = username
      @password = password
    end

    def self.nested_resource(name)
      define_method name.to_sym do |*args|
        resource = [name.to_s, *args.first].compact.join('/')
        Resource.new(@connection, nested_resource_path(resource))
      end
    end

    def nested_resource_path(nested_resource = '')
      components = @uri.request_uri.split('/')
      components << "" if components.empty?
      components << nested_resource
      components.join('/')
    end

    def put(options_or_body = '')
      do_request(options_or_body, Net::HTTP::Put)
    end

    def get(options_or_body = '')
      do_request(options_or_body, Net::HTTP::Get)
    end

    def delete(options_or_body = '')
      do_request(options_or_body, Net::HTTP::Delete)
    end

    def post(options_or_body = '')
      do_request(options_or_body, Net::HTTP::Post)
    end

    private
      def do_request(options_or_body, request_const)
        request_uri = nil
        request_body = nil
        if options_or_body.is_a?(String)
          request_uri = @uri.request_uri
          request_body = options_or_body
        elsif options_or_body.is_a?(Hash)
          uri = @uri.dup
          uri.query = (options_or_body[:query] || {}).to_query
          request_uri = uri.request_uri
          request_body = options_or_body[:body]
        end
        request = request_const.new(request_uri)
        request['Content-Type'] = 'application/json'
        
        request.body = if request_body.is_a?(String)
          request_body
        else
          request_body.to_json
        end

        if @username and @password
          request.basic_auth(@username, @password)
        end
        
        response = @connection.start do |http|
          http.request(request)
        end

        [response, JSON.parse(response.body)]
      end
  end
end

