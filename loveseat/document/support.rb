module Loveseat
  module Document
    class Support
      attr_accessor :properties, :dsl

      TYPE = 0
      DEFAULT= 1

      def initialize(klass, options = {})
        @klass = klass
        @properties = {}
        @dsl = DSL.new(self)
        @abstract = !!options[:abstract]
        
        klass.class_eval("
          def __loveseat_instance_adapter
            @__loveseat_instance_adapter ||= Loveseat::Document::InstanceAdapter.new(self.class.name)
          end
        ")

        unless @abstract
          add_property(:_id, Property::String)
          add_property(:_rev, Property::String)
        end
      end

      def add_property(name,type,default = nil)
        method = name.to_sym
        @properties[name] = [type, default]
        @klass.class_eval do
          define_method(method) do
            __loveseat_instance_adapter[method].get
          end
          define_method("#{method}=".to_sym) do |value|
            __loveseat_instance_adapter[method].set(value)
          end
        end
      end

      def to_doc(instance)
        doc = {}
        instance.__loveseat_instance_adapter.property_map.each do |k,v|
          value = v.get 
          doc[k] = value unless v.empty?
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

      def generate_property_map
        map = {}
        properties.each do |name,value|
          type, default = value
          map[name] = type.new(default)
        end
        map
      end

      def abstract?
        @abstract
      end
    end
  end
end
