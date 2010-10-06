module Stoner
  module Document
    class Support
      attr_accessor :properties, :dsl

      def initialize(klass)
        @klass = klass
        @properties = {}
        @dsl = DSL.new(self)
        
        klass.class_eval("
          def __stoner_document
            @__stoner_document ||= {}
          end
        ")
        add_property(:_id, Types::String.new)
        add_property(:_rev, Types::String.new)
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
          doc[k] = value unless v.empty?(value)
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

      private

        class DSL
          def initialize(support)
            @support = support 
          end

          def integer(name, default = nil)
            property = Types::Integer.new(default)
            @support.add_property(name,property)
          end

          def string(name, default = nil)
            property = Types::String.new(default)
            @support.add_property(name,property)
          end

          def float(name, default = nil)
            property = Types::Float.new(default)
            @support.add_property(name,property)
          end
          
          def date(name, default = nil)
            property = Types::Date.new(default)
            @support.add_property(name,property)
          end
          
          def time(name, default = nil)
            property = Types::Time.new(default)
            @support.add_property(name,property)
          end

          def hash(name, default = nil)
            property = Types::Hash.new(default)
            @support.add_property(name,property)
          end
          
          def array(name, default = nil)
            property = Types::Array.new(default)
            @support.add_property(name,property)
          end
        end
    end
  end
end
