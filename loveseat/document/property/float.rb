module Loveseat
  module Document
    module Property
      class Float < Base
        def self.cast(value)
          value.to_f
        end
      end
    end
  end
end
