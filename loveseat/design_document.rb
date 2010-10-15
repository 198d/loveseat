module Loveseat
  module DesignDocument 
    def self.view(db, design_document, name, options = {})
      klass = design_document.class.name
      resource = Rest::DesignDocument.new(db, klass)
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

    def self.resolve(id)
      prefix, klass = id.split('/')
      klass
    end
    extend Document::API
  end
end
