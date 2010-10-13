module Stoner
  module Document
    @@registry = {}
    
    def self.registry
      @@registry
    end
    
    def self.next_id(server, klass)
      response, body = server._uuids.get
      response.value

      uuid = body['uuids'].first
      "#{klass.name}:#{uuid}"
    end

    def self.resolve(id)
      klass, uuid = id.split(':')
      klass
    end
    
    module API
      def setup(klass, options = {}, &block)
        support = self::Support.new(klass, options)
        registry[klass.name] = support
        yield(support.dsl) if block_given?
        support
      end

      def put(db, object)
        support = registry[object.class.name]
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

      def get(db, id)
        resource = Rest::Document.new(db, id)
        response, body = resource.get
        response.value

        klass = resolve(id)
        support = registry[klass]
        support.from_hash(body)
      end

      def all(db, klass)
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

      def delete(db, object)
        resource = Rest::Document.new(db, object._id)
        response, body = resource.delete(:query => {:rev => object._rev})
        response.value
      end

    end
    extend API
  end
end

