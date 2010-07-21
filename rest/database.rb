module Rest
  class Database < Resource
    nested_resource :_all_docs
    nested_resource :_revs_limit
    nested_resource :_changes
    nested_resource :_bulk_docs
    nested_resource :_temp_view
    nested_resource :_view_cleanup
    nested_resource :_compact

    def initialize(server, name)
      super(server.connection, "/#{name}/")
    end
  end
end
