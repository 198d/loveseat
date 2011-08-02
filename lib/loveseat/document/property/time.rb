require 'time'

module Loveseat
  module Document
    module Property
      class Time < Base
        def self.cast(value)
          if value.is_a?(::Time)
            return value
          end

          ::Time.parse(value)
        end
      end

      class UpdateTime < Time
        def now!
          set(::Time.now)
        end
      end

      class CreateTime < Time
        def once!
          set(::Time.now)
        end
      end
    end
  end
end
