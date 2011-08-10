module Loveseat
  module Document
    class InstanceAdapter
      def initialize(instance)
        @instance = instance
        @klass = instance.is_a?(Class) ? instance : instance.class
        @support = Document.registry[@klass.name]
      end

      def [](name)
        property_map[name]
      end

      def inspect
        "#<Loveseat::Document::InstanceAdapter:#{@instance}>"
      end


      def set(attributes)
        attributes.each do |name, value|
          property = self[name.to_sym]
          setter = :"#{name}="
          unless property.nil?
            property.set(value)
          else
            property_map[name.to_sym] = Property::Raw.new(value)
          end
          @instance.send(setter, property.get) if @instance.respond_to?(setter)
        end
      end

      def to_doc
        doc = {}
        update!

        property_map.each do |name,property|
          property.now!
          property.once! if property.empty?
          value = property.to_doc
          doc[name.to_s] = value unless property.empty?
        end

        doc
      end

      def to_json
        to_doc.to_json
      end

      def property_map
        @property_map ||= @support.generate_property_map
      end

      def update!
        property_map.each do |attribute, property|
          if @instance.respond_to?(attribute)
            value = @instance.send(attribute)
            property.set(value)
          end
        end
      end
    end
  end
end
