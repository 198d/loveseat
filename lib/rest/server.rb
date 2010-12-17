module Rest
  class Server < Resource
    nested_resource :_all_dbs
    nested_resource :_config
    nested_resource :_uuids
    nested_resource :_replicate
    nested_resource :_stats
    nested_resource :_active_tasks

    def initialize(host, port)
      super(Net::HTTP.new(host, port), '/')
    end
  end
end
