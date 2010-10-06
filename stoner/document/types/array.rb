module Stoner
  module Document
    module Types
      class Array < Base
        def self.cast(value)
          value.to_a
        end
      end
    end
  end
end
