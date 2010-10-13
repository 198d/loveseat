module Stoner
  module DesignDocument
    class ViewRow
      Stoner::Document.setup(self, :abstract => true) do |s|
        s.string :id
        s.raw :key
        s.raw :value
        s.hash :doc
      end

      def self.from_hash(doc)
        Document.registry[self.name].from_hash(doc)
      end
    end
  end
end
