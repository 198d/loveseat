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

      def timestamped
        @support.add_property(:created, Property::CreateTime, nil)
        @support.add_property(:updated, Property::UpdateTime, nil)
      end

      def embeded(name, klass_name = nil, &block)
        klass_name ||= name.to_s.capitalize.gsub(/_([a-z])/) { |match| $1.capitalize }

        begin
          type = @support.klass.const_get(klass_name.to_sym)
        rescue NameError
          type = @support.klass.const_set(klass_name, Class.new(Model))
          Document.setup(type, {:abstract => true},  &block)
        end

        @support.add_property(name, Property::EmbededDocument, type)
      end
    end
  end
end
