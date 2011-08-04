module Loveseat
  class EmbededModel < Document::Base
    def self.setup(options = {}, &block)
      Document.setup(self, options.merge(:abstract => true), &block)
    end
  end
end
