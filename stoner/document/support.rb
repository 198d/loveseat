module Stoner
  module Document
    class Support
      def initialize(klass)
        @klass = klass
        @properties = []
        Stoner::Document.registry[@klass] = self
      end

      def integer(name, default = nil)
        property = Types::Integer.new(default)
        add_property(property)
      end

      def string(name, default = nil)
        property = Types::String.new(default)
        add_property(property)
      end

      private 
        def add_property(property)
          @properties << property
          @klass.class_eval do
            define_method(name.to_sym) do
              property.get
            end
            define_method("#{name}=".to_sym) do |value|
              property.set(value)
            end
          end
        end
    end
  end
end
