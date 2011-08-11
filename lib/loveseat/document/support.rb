module Loveseat
  module Document
    class Support
      attr_reader :properties, :dsl, :klass

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
      end

      def alter_property(name,type,*args)
        @properties[name] = [type, args]
      end

      def from_doc(doc, object = nil)
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
              @__loveseat_instance_adapter ||= Loveseat::Document::InstanceAdapter.new(self)
            end
          SOURCE
          eval_appropriately(method)
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
