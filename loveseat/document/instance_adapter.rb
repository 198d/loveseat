module Loveseat
  module Document
    class InstanceAdapter
      def initialize(klass)
        @support = Document.registry[klass]
        @klass = klass
      end

      def [](name)
        property_map[name]
      end

      def inspect
        "#<Loveseat::Document::InstanceAdapter:#{@klass}>"
      end

      def property_map
        @property_map ||= @support.generate_property_map
      end
    end
  end
end
