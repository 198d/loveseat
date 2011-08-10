module Loveseat
  module EmbededDocument
    def self.setup(klass, options = {}, &block)
      Document.setup(klass, options.merge(:abstract => true), &block)
    end
  end
end
