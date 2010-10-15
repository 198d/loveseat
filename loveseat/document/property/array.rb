module Loveseat
  module Document
    module Property
      class Array < Base
        def self.cast(value)
          value.to_a
        end
        
        def empty?
          @value.nil? || @value.empty?
        end
      end
    end
  end
end
