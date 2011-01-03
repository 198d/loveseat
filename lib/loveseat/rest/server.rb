module Loveseat
  module Rest
    class Server < Resource
      attr_reader :user, :password

      nested_resource :_all_dbs
      nested_resource :_config
      nested_resource :_uuids
      nested_resource :_replicate
      nested_resource :_stats
      nested_resource :_active_tasks

      def initialize(host, port, user=nil, password=nil)
        @user = user
        @password = password
        super(Net::HTTP.new(host, port), '/', user, password)
      end
    end
  end
end
