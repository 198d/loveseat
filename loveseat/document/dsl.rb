module Loveseat
  module Document
    class DSL
      def initialize(support)
        @support = support 
      end

      def integer(name, default = nil)
        @support.add_property(name, Types::Integer, default)
      end

      def string(name, default = nil)
        @support.add_property(name, Types::String, default)
      end

      def float(name, default = nil)
        @support.add_property(name, Types::Float, default)
      end
      
      def date(name, default = nil)
        @support.add_property(name, Types::Date, default)
      end
      
      def time(name, default = nil)
        @support.add_property(name, Types::Time, default)
      end

      def hash(name, default = nil)
        @support.add_property(name, Types::Hash, default)
      end
      
      def array(name, default = nil)
        @support.add_property(name, Types::Array, default)
      end
      
      def raw(name, default = nil)
        @support.add_property(name, Types::Raw, default)
      end
    end
  end
end
