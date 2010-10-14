module Stoner
  module Document
    module Types
      class Float < Base
        def self.cast(value)
          value.to_f
        end
      end
    end
  end
end
