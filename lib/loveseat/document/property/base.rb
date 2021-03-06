module Loveseat
  module Document
    module Property
      class Base
        attr_reader :value

        def initialize(default_value = nil)
          @value = cast(default_value)
        end

        def get
          @value
        end

        def set(value)
          @value = cast(value)
        end

        def empty?
         @value.nil?
        end

        def now!
          nil
        end

        def once!
          nil
        end

        def to_doc
          get
        end

        def self.cast(value)
          value
        end

        private
          def cast(value)
            self.class.cast(value) unless value.nil?
          end
      end
    end
  end
end
