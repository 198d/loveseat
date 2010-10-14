require 'time'

module Loveseat
  module Document
    module Types
      class Time < Base
        def self.cast(value)
          if value.is_a?(::Time)
            return value
          end

          ::Time.parse(value)
        end
      end
    end
  end
end
