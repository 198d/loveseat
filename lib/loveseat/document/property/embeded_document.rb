module Loveseat
  module Document
    module Property
      class EmbededDocument < Base
        def initialize(type)
          @type = type
          super(nil)
        end

        private
          def cast(value)
            if value.is_a?(::Hash)
              support = Loveseat::Document.registry[@type.to_s]
              support.from_hash(value)
            elsif value.is_a?(@type)
              value
            elsif value.is_a?(::Array)
              value.map { |doc| cast(doc) }
            else
              # raise?
            end
          end
      end
    end
  end
end
