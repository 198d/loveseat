module Stoner
  module Document
    @@registry = {}

    def self.setup(klass, &block)
      support = Support.new(klass)
      registry[klass.name] = support
      yield(support.dsl)
      support
    end

    def self.put(db, object)
      support = registry[object.class.name]
      raise "Not Registered" if support.nil?
      
      if object._id.nil?
        object._id = next_id(db.server, object.class)
      end

      resource = Rest::Document.new(db, object._id)
      response, body = resource.put(support.to_doc(object))

      response.value

      object._rev = body["rev"]
      object
    end

    def self.get(db, id)
      resource = Rest::Document.new(db, id)
      response, body = resource.get
      response.value

      klass, uuid = id.split(':')
      support = registry[klass]
      support.from_hash(body)
    end

    def self.all(db, klass)
      support = registry[klass.name]
      resource = db._all_docs
      response, body = resource.get(:query => {:startkey => "#{klass.name}:".to_json,
                                               :endkey => "#{klass.name}:\u0fff".to_json,
                                               :include_docs => true})
      response.value

      body['rows'].map do |row|
        support.from_hash(row['doc'])
      end
    end

    def self.delete(db, object)
      resource = Rest::Document.new(db, object._id)
      response, body = resource.delete(:query => {:rev => object._rev})
      response.value
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

