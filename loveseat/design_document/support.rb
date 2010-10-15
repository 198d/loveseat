module Loveseat
  module DesignDocument
    class Support < Document::Support
      def initialize(*args)
        super(*args)
        @dsl = DSL.new(self)
        add_property(:views, Document::Types::Hash.new({}))
      end

      def add_view(name, options = {})
        property = properties.delete(:views)
        views = property.default_value.merge(name.to_sym => options)
        add_property(:views, Document::Types::Hash.new(views))
      end 
    end
  end
end
