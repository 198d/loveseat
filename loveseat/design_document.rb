module Loveseat
  module DesignDocument 
    Document.add_resolver(/_design\/([A-Za-z:]+)/)

    def self.setup(klass, options = {}, &block)
      Document.setup(klass, { :support => Support.new(klass, options) }, &block)
    end
    
    def self.view(db, design_document, name, options = {})
      resource = Rest::DesignDocument.new(db, design_document.name)
      view_resource = resource._view(name)

      keys = options.delete(:keys)
      
      response, body = if keys
        view_resource.post(:query => options, :body => {:keys => keys}.to_json)
      else
        view_resource.get(:query => options)
      end
      response.value
      
      body['rows'].map do |row|
        ViewRow.from_hash(row)
      end
    end

    def self.generate_id(klass)
      "_design/#{klass.name}"
    end
  end
end
