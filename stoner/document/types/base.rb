module Stoner
  module Document
    module Types
      class Base
        def initialize(value = nil)
          @value = cast(value)
        end

        def get
          cast(@value)
        end

        def set(value)
          @value = cast(value)
        end

        def to_json(*args)
          @value.to_json(*args)
        end

        private
          def cast(value)
            self.class.cast(value) unless value.nil?
          end
      end
    end
  end
end
