module Loveseat
  module DesignDocument
    class DSL < Document::DSL
      def view(name, functions = {})
        @support.add_view(name, functions)
      end
    end
  end
end
