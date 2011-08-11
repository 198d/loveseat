module Loveseat
  module Document
    module Property
      class EmbededDocument < Base
        def initialize(type)
          @type = type
          @support = Loveseat::Document.registry[@type.to_s]
          super(nil)
        end

        def to_doc
          return nil if @value.nil?

          if @value.is_a?(::Array)
            @value.map do |instance|
              instance.__loveseat_instance_adapter.to_doc
            end
          else
            @value.__loveseat_instance_adapter.to_doc
          end
        end

        private
          def cast(value)
            if value.is_a?(::Hash)
              @support.from_doc(value)
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
