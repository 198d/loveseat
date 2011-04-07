module Loveseat
  module Document
    @@registry = {}
    @@uuids = []
    @@resolvers = [
      /^([A-Za-z:]+):/
    ]
    
    def self.registry
      @@registry
    end

    def self.add_resolver(regexp)
      @@resolvers << regexp
    end
    
    def self.next_id(server, klass)
      if @@uuids.empty?
        response, body = server._uuids.get(:query => {:count => 100})
        response.value
        @@uuids = body['uuids']
      end

      uuid = @@uuids.pop
      "#{klass.name}:#{uuid}"
    end

    def self.resolve(id)
      @@resolvers.each do |regexp|
        match = regexp.match(id)
        if match
          return match[1]
        end
      end
      nil
    end
    
    def self.setup(klass, options = {}, &block)
      support = options.delete(:support) ||
                  Support.new(klass, options)
      Document.registry[klass.name] = support
      support.dsl.instance_eval(&block)
      support
    end

    def self.put(db, object)
      klass = ( object.instance_of?(Class) ) ? object : object.class
      support = Document.registry[klass.name]
      raise "Not Registered" if support.nil?
      raise "Abstract Document" if support.abstract?
      
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

      klass = resolve(id)
      support = Document.registry[klass]
      support.from_hash(body)
    end

    def self.all(db, klass)
      support = Document.registry[klass.name]
      resource = db._all_docs
      response, body = resource.get(:query => {:startkey => "#{klass.name}:".to_json,
                                               :endkey => "#{klass.name}:\ufff0".to_json,
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
      object._rev = nil
    end
  end
end

