module Loveseat
  module Rest
    class Server < Resource
      attr_reader :username
      attr_reader :password

      nested_resource :_all_dbs
      nested_resource :_config
      nested_resource :_uuids
      nested_resource :_replicate
      nested_resource :_stats
      nested_resource :_active_tasks

      def initialize(host, port, username=nil, password=nil)
        @username = username
        @password = password
        super(Net::HTTP.new(host, port), '/', username, password)
      end
    end
  end
end
