module Stoner
  module Document
    @@registry = {}

    def self.setup(klass, &block)
      support = Support.new(klass)
      yield(support)
      support
    end
    
    def self.registry
      @@registry
    end
  end
end

