module Loveseat
  module Document
    module Types
      class Array < Base
        def self.cast(value)
          value.to_a
        end
        
        def self.empty?(value)
          value.nil? || value.empty?
        end
      end
    end
  end
end
