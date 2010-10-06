module Stoner
  module Document
    module Types
      class Base
        def initialize(default_value = nil)
          @default_value = cast(default_value)
        end

        def default_value
          @default_value
        end

        def empty?(value)
          cast(value).nil?
        end

        def cast(value)
          self.class.cast(value) unless value.nil?
        end
      end
    end
  end
end
