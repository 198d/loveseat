require 'date'

module Loveseat
  module Document
    module Property
      class Date < Base
        def self.cast(value)
          if value.is_a?(::Date)
            return value
          end

          ::Date.parse(value)
        end
      end
    end
  end
end
