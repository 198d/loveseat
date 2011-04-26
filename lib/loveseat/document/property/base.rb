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

        def auto!
          true
        end
        
        private 
          def cast(value)
            self.class.cast(value) unless value.nil?
          end
      end
    end
  end
end
