module Stoner
  module Document
    class Support
      attr_accessor :properties

      def initialize(klass)
        @klass = klass
        @properties = {}
        Stoner::Document.registry[@klass] = self
        add_property(:_id, Types::String.new)
        add_property(:_rev, Types::String.new)
      end

      def integer(name, default = nil)
        property = Types::Integer.new(default)
        add_property(name,property)
      end

      def string(name, default = nil)
        property = Types::String.new(default)
        add_property(name,property)
      end

      def float(name, default = nil)
        property = Types::Float.new(default)
        add_property(name,property)
      end
      
      def date(name, default = nil)
        property = Types::Date.new(default)
        add_property(name,property)
      end
      
      def time(name, default = nil)
        property = Types::Time.new(default)
        add_property(name,property)
      end

      private 
        def add_property(name,property)
          @properties[name.to_sym] = property
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
