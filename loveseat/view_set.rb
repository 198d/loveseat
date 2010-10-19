module Loveseat
  class ViewSet < Model
    def self.setup(options = {}, &block)
      options = options.merge(:singleton => true)
      Loveseat::DesignDocument.setup(self, options, &block)
    end

    def self.put
      Loveseat::Document.put(self.database, self)
    end

    def self.delete
      Loveseat::Document.delete(self.database, self)
    end

    def self.latest!
      begin
        put
      rescue 
        Loveseat::Document.get(self.database, self._id)
      end
    end
  
    def self.get(*args)
      latest!
    end

    private :put, :delete
  end
end
