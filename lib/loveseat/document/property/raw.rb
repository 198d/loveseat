module Loveseat
  module Document
    module Property
      class Raw < Base
        def self.cast(value)
          value
        end
      end
    end
  end
end
