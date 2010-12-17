module Loveseat
  module Document
    module Property
      class Integer < Base
        def self.cast(value)
          value.to_i
        end
      end
    end
  end
end
