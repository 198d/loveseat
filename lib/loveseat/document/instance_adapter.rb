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

      def set(attributes)
        attributes.each do |name, value|
          property = self[name.to_sym]
          unless property.nil?
            property.set(value)
          else
            property_map[name.to_sym] = Property::Raw.new(value)
          end
        end
      end

      def to_doc
        doc = {}
        property_map.each do |name,property|
          property.now!
          property.once! if property.empty?
          value = property.get 
          doc[name.to_s] = value unless property.empty?
        end
        doc
      end

      def property_map
        @property_map ||= @support.generate_property_map
      end
    end
  end
end
