module Loveseat
  class ViewSet < Model
    def self.setup(options = {}, &block)
      options = options.merge(:singleton => true)
      DesignDocument.setup(self, options, &block)
    end
   
    def self.view(name, options = {})
      DesignDocument.view(self.database, self, name, options)
    end 

    def self.put
      Document.put(self.database, self)
    end

    def self.delete
      Document.delete(self.database, self)
    end

    def self.latest!
      begin
        put
      rescue 
        Document.get(self.database, self._id)
        retry
      end
    end
  
    def self.get(*args)
      latest!
    end

    def self.all
      DesignDocument.all(self.database)       
    end

    private :put, :delete
  end
end
