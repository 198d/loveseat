module Loveseat
  module Rest
    class Document < Resource
      attr_reader :database
      attr_reader :id

      def initialize(database, id)
        @database = database
        @id = id
        super(database.connection, database.nested_resource_path(id), database.server.user, database.server.password)
      end
    end
  end
end
