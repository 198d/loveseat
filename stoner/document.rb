module Stoner
  module Document
    @@registry = {}

    def self.setup(klass, &block)
      support = Support.new(klass)
      yield(support)
      support
    end

    def self.put(db, object)
      support = registry[object.class]
      raise "Not Registered" if support.nil?
      
      if object._id.nil?
        object._id = next_id(db.server, object.class)
      end

      properties = support.properties.clone
      properties.delete_if do |k,v|
        v.get.nil?
      end

      resource = Rest::Document.new(db, object._id)
      response, body = resource.put(properties.to_json)

      response.value

      object._rev = body["rev"]
      object
    end

    def self.delete(db, object)
      resource = Rest::Document.new(db, object._id)
      response, body = resource.delete(:query => {:rev => object._rev})
      response.value
    end

    def self.all(db, klass)
      resource = db._all_docs
      response, body = resource.get(:query => {:startkey => "#{klass.name}:".to_json,
                                               :endkey => "#{klass.name}:\u0fff".to_json,
                                               :include_docs => true})
      response.value

      body['rows'].map do |row|
        object = klass.new
        row['doc'].each do |k,v|
          object.send("#{k}=", v)
        end
        object
      end
    end

    def self.next_id(server, klass)
      response, body = server._uuids.get
      response.value

      uuid = body['uuids'].first
      "#{klass.name}:#{uuid}"
    end
    
    def self.registry
      @@registry
    end
  end
end

