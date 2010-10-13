module Stoner
  module Document
    class Support
      attr_accessor :properties, :dsl

      def initialize(klass, options = {})
        @klass = klass
        @properties = {}
        @dsl = DSL.new(self)
        @abstract = !!options[:abstract]
        
        klass.class_eval("
          def __stoner_document
            @__stoner_document ||= {}
          end
        ")
        unless @abstract
          add_property(:_id, Types::String.new)
          add_property(:_rev, Types::String.new)
        end
      end

      def add_property(name,property)
        name = name.to_sym
        @properties[name] = property
        @klass.class_eval do
          define_method(name) do
            __stoner_document[name] ||= property.default_value
          end
          define_method("#{name}=".to_sym) do |value|
            __stoner_document[name] = property.cast(value)
          end
        end
      end

      def to_doc(instance)
        doc = {}
        properties.each do |k,v|
          value = instance.send(k)
          doc[k] = value unless v.class.empty?(value)
        end
        doc.to_json
      end

      def from_hash(doc)
        object = @klass.new
        properties.each do |k,v|
          object.send(:"#{k}=", doc[k.to_s])
        end
        object
      end

      def abstract?
        @abstract
      end
    end
  end
end
