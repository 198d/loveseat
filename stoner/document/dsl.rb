module Stoner
  module Document
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
        property = Types::Hash.new(default || {})
        @support.add_property(name,property)
      end
      
      def array(name, default = nil)
        property = Types::Array.new(default || [])
        @support.add_property(name,property)
      end
      
      def raw(name, default = nil)
        property = Types::Raw.new(default)
        @support.add_property(name,property)
      end
    end
  end
end
