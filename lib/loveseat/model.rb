module Loveseat
  class Model
    def self.connection=(connection_hash)
      @@server = Rest::Server.new(connection_hash[:host],
                                connection_hash[:port],
                                connection_hash[:user],
                                connection_hash[:password])
      @@database = Rest::Database.new(@@server, connection_hash[:database])
    end

    def put
      Document.put(self.class.database, self)
    end
  
    def delete
      Document.delete(self.class.database, self)
    end 

    def attach(stream, options = {})
      options = { :force => false }.merge(options) 
      Document.attach(self.class.database, self, stream, options)
    end

    def attach!(stream, options = {})
      attach(stream, options.merge(:force => true))
    end

    def to_json(*args)
      Document.registry[self.class.name].to_doc(self)
    end

    def self.get(id)
      unless id[self.name]
        id = [self.name, id].join(':')
      end
      Document.get(self.database, id)
    end

    def self.all
      Document.all(self.database, self)
    end

    def self.setup(options = {}, &block)
      Document.setup(self, options, &block)
    end

    def self.server
      @@server
    end

    def self.database
      @@database
    end
  end
end
