module Loveseat
  module Document
    module Types
      class String < Base
        def self.cast(value)
          value.to_s
        end
      end
    end
  end
end
