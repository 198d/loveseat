module Loveseat
  module Document
    module Types
      class Integer < Base
        def self.cast(value)
          value.to_i
        end
      end
    end
  end
end
