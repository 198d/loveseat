module Loveseat
  module DesignDocument
    class Support < Document::Support
      def initialize(klass, options = {})
        super(klass, options)
        @dsl = DSL.new(self)
        add_property(:views, Document::Property::Hash, {})
        alter_property(:_id, Document::Property::String, DesignDocument.generate_id(klass))
      end

      def from_doc(doc)
        object = super(doc)
        object.views = properties[:views][DEFAULT]
        object
      end

      def add_view(name, options = {})
        type, args = properties[:views]
        default = args.first
        default.merge!(
          name => options
        )
      end
    end
  end
end
