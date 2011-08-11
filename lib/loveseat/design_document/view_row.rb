module Loveseat
  module DesignDocument
    class ViewRow
      attr_accessor :id, :key, :value, :doc

      Loveseat::EmbededDocument.setup(self) do
        string :id
        raw :key
        raw :value
        hash :doc
      end

      def self.from_doc(doc)
        Document.registry[self.name].from_doc(doc)
      end
    end
  end
end
