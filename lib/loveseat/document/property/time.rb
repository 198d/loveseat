require 'time'

module Loveseat
  module Document
    module Property
      class Time < Base
        def initialize(default_value, options = {})
          @options = options
          super(default_value)
        end

        def auto!
          auto_now = @options[:auto_now]
          if auto_now == :always or (auto_now == :once and empty?)
            @value = ::Time.now
          end
        end

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
