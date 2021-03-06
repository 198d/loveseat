module Loveseat
  module Document
    class Base
      def initialize(attributes = {})
        __loveseat_instance_adapter.set(attributes)
        self
      end

      def to_doc
        Document.registry[self.class.name].to_doc(self)
      end

      def to_json(*args)
        Document.registry[self.class.name].to_json(self)
      end
    end
  end
end
