require 'mime/types'

module Loveseat
  module Document
    class NotRegisteredError < RuntimeError; end
    class AbstractDocumentError < RuntimeError; end

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

      uuid = @@uuids.shift
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
      raise NotRegisteredError.new("Not Registered") if support.nil?
      raise AbstractDocumentError.new("Abstract Document") if support.abstract?

      adapter = object.__loveseat_instance_adapter

      _id = adapter[:_id]
      _rev = adapter[:_rev]
      _attachments = adapter[:_attachments]

      if _id.get.nil?
        _id.set(next_id(db.server, object.class))
      end

      resource = Rest::Document.new(db, _id.get)
      response, body = resource.put(adapter.to_json)

      response.value

      _attachments.get.each do |name,metadata|
        data = metadata.delete('data')
        unless data.nil?
          metadata['stub'] = true
          metadata['length'] = data.size
        end
      end

      _rev.set(body["rev"])
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
      raise NotRegisteredError.new('Not Registered') if support.nil?

      resource = db._all_docs
      response, body = resource.get(:query => {:startkey => "#{klass.name}:".to_json,
                                               :endkey => "#{klass.name}:\ufff0".to_json,
                                               :include_docs => true})
      response.value

      body['rows'].map do |row|
        support.from_hash(row['doc'])
      end
    end

    def self.attach(db, object, stream, options={})
      options = { :force => false }.merge(options)
      name = options[:name] || File.basename(stream.path)
      content_type = options[:content_type] ||
        MIME::Types.type_for(name).first.to_s

      adapter = object.__loveseat_instance_adapter
      _id = adapter[:_id]
      _rev = adapter[:_rev]
      _attachments = adapter[:_attachments]

      if options[:force]
        document = Rest::Document.new(db,_id.get)
        attachment = Rest::Attachment.new(document, name, content_type)
        response, body = attachment.put({:query => {:rev => _rev.get}, :body => stream.read})
      else
        _attachments.get[name] = {
          'content_type' => content_type,
          'data' => [stream.read].pack('m')
        }
        return true
      end

      response.value
      body['ok']
    end

    def self.delete(db, object)
      adapter = object.__loveseat_instance_adapter
      _id = adapter[:_id]
      _rev = adapter[:_rev]

      resource = Rest::Document.new(db, _id.get)
      response, body = resource.delete(:query => {:rev => _rev.get})
      response.value

      _rev.set(body['rev'])
      body['ok']
    end
  end
end

