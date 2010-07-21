module Rest
  class Document < Resource
    def initialize(database, id)
      super(database.connection, database.nested_resource_path(id))
    end
  end
end
