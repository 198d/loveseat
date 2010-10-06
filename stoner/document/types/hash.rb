module Stoner
  module Document
    module Types
      class Hash < Base
        def self.cast(value)
          value.to_h
        end
      end
    end
  end
end
