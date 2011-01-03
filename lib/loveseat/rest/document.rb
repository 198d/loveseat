module Loveseat
  module Rest
    class Document < Resource
      def initialize(database, id)
        super(database.connection, database.nested_resource_path(id), database.server.user, database.server.password)
      end
    end
  end
end
