module Loveseat
  module Document
    class DSL
      def initialize(support)
        @support = support 
      end

      def integer(name, default = nil)
        @support.add_property(name, Property::Integer, default)
      end

      def string(name, default = nil)
        @support.add_property(name, Property::String, default)
      end

      def float(name, default = nil)
        @support.add_property(name, Property::Float, default)
      end
      
      def date(name, default = nil)
        @support.add_property(name, Property::Date, default)
      end
      
      def time(name, default = nil)
        @support.add_property(name, Property::Time, default)
      end

      def hash(name, default = nil)
        @support.add_property(name, Property::Hash, default)
      end
      
      def array(name, default = nil)
        @support.add_property(name, Property::Array, default)
      end
      
      def raw(name, default = nil)
        @support.add_property(name, Property::Raw, default)
      end

      def embeded(name, type)
        @support.add_property(name, Property::EmbededDocument, type)
      end

      def timestamped
        @support.add_property(:created, Property::Time, nil, :auto_now => :once)
        @support.add_property(:updated, Property::Time, nil, :auto_now => :always)
      end
    end
  end
end
