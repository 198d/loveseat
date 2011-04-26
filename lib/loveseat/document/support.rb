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
        @singleton = !!options[:singleton]

        add_instance_adapter_accessor!

        unless abstract?
          add_property(:_id, Property::String)
          add_property(:_rev, Property::String)
          add_property(:_attachments, Property::Hash, {})
        end
      end

      def add_property(name,type,*args)
        name = name.to_sym
        alter_property(name,type,*args)
        add_instance_methods!(name)
      end

      def alter_property(name,type,*args)
        @properties[name] = [type, args]
      end

      def to_doc(instance)
        instance.__loveseat_instance_adapter.to_doc
      end

      def to_json(instance)
        to_doc(instance).to_json
      end

      def from_hash(doc, object = nil)
        if object.nil?
          if singleton?
            object = @klass
          else
            object = @klass.new
          end
        end
        object.__loveseat_instance_adapter.set(doc)
        object
      end

      def generate_property_map
        map = {}
        properties.each do |name,value|
          type, args = value
          clone = Marshal.load(Marshal.dump(args)) 
          map[name] = type.new(*clone)
        end
        map
      end

      def singleton?
        @singleton
      end

      def abstract?
        @abstract
      end

      private

        def add_instance_adapter_accessor!
          method = <<-SOURCE
            def __loveseat_instance_adapter
              class_name = ( self.instance_of?(Class) ) ? self.name : self.class.name
              @__loveseat_instance_adapter ||= Loveseat::Document::InstanceAdapter.new(class_name)
            end
          SOURCE
          eval_appropriately(method)
        end

        def add_instance_methods!(method)
          methods = <<-SOURCE
            def #{method}
              __loveseat_instance_adapter["#{method}".to_sym].get
            end
            def #{method}=(value)
              __loveseat_instance_adapter["#{method}".to_sym].set(value)
            end
          SOURCE
          eval_appropriately(methods)
        end
        
        def eval_appropriately(arg)
          if singleton?
            @klass.instance_eval(arg)
          else
            @klass.class_eval(arg)
          end
        end
    end
  end
end
