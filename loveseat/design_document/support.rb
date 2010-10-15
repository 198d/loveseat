module Loveseat
  module DesignDocument
    class Support < Document::Support
      def initialize(klass, options = {})
        super(klass, options)
        @dsl = DSL.new(self)
        add_property(:views, Document::Property::Hash, {})
        alter_property(:_id, Document::Property::String, DesignDocument.generate_id(klass))
      end

      def add_view(name, options = {})
        type, default = properties[:views]
        default.merge!(
          name => options
        )
      end 
    end
  end
end
