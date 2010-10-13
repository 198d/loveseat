module Stoner
  module Document
    module Types
      class Raw < Base
        def self.cast(value)
          value
        end
      end
    end
  end
end
