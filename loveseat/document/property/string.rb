module Loveseat
  module Document
    module Property
      class String < Base
        def self.cast(value)
          value.to_s
        end
      end
    end
  end
end
