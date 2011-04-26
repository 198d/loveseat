require 'uri'

module Loveseat
  module Rest
    class Attachment < Resource
      def initialize(document, name, content_type)
        @content_type = content_type
        
        database = document.database
        path = "#{document.id}/#{URI.encode(name)}"

        super(database.connection, database.nested_resource_path(path), database.server.user, database.server.password)
      end

      private
        def build_request(const, uri, body)
          request = const.new(uri)
          request.body = body
          request['Content-Type'] = @content_type
          request
        end
    end
  end
end
