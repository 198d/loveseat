module Loveseat
  module Document
    module Property
      class Hash < Base
        def self.cast(value)
          value.to_hash
        end

        def empty?
          @value.nil? || @value.empty?
        end
      end
    end
  end
end
