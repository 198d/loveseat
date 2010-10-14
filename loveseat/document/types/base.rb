module Loveseat
  module Document
    module Types
      class Base
        attr_reader :default_value

        def initialize(default_value = nil)
          @default_value = cast(default_value)
        end

        def self.empty?(value)
          value.nil?
        end

        def cast(value)
          self.class.cast(value) unless value.nil?
        end
      end
    end
  end
end
