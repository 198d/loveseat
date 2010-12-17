module Loveseat
  module DesignDocument
    class ViewRow
      Loveseat::Document.setup(self, :abstract => true) do 
        string :id
        raw :key
        raw :value
        hash :doc
      end

      def self.from_hash(doc)
        Document.registry[self.name].from_hash(doc)
      end
    end
  end
end
