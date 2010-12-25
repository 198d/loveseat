module Loveseat
  module Rest
    class DesignDocument < Document
      nested_resource :_view
    
      def initialize(database, name)
        super(database, "_design/#{name}")
      end
    end
  end
end
