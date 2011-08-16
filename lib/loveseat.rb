require 'core_ext/hash.rb'
require 'loveseat/rest/resource.rb'
require 'loveseat/rest/server.rb'
require 'loveseat/rest/document.rb'
require 'loveseat/rest/attachment.rb'
require 'loveseat/rest/database.rb'
require 'loveseat/rest/design_document.rb'
require 'loveseat/document.rb'
require 'loveseat/embeded_document.rb'
require 'loveseat/document/base.rb'
require 'loveseat/document/dsl.rb'
require 'loveseat/document/support.rb'
require 'loveseat/document/instance_adapter.rb'
require 'loveseat/document/property/base.rb'
require 'loveseat/document/property/string.rb'
require 'loveseat/document/property/integer.rb'
require 'loveseat/document/property/float.rb'
require 'loveseat/document/property/date.rb'
require 'loveseat/document/property/time.rb'
require 'loveseat/document/property/array.rb'
require 'loveseat/document/property/hash.rb'
require 'loveseat/document/property/raw.rb'
require 'loveseat/document/property/embeded_document.rb'
require 'loveseat/design_document.rb'
require 'loveseat/design_document/dsl.rb'
require 'loveseat/design_document/support.rb'
require 'loveseat/design_document/view_row.rb'
require 'loveseat/model.rb'
require 'loveseat/view_set.rb'

def Loveseat(object)
  clone = Marshal.load(Marshal.dump(object))
  clone.extend Loveseat::WrappedDocument
  clone
end

module Loveseat
  def self.uri=(uri)
    @uri = URI.parse(uri)
    connection_hash = {
      :host => uri.host,
      :port => uri.port,
      :user => uri.user,
      :password => uri.password,
      :database => uri.path.gsub('/', '')
    }

    @server = Rest::Server.new(connection_hash[:host],
                                connection_hash[:port],
                                connection_hash[:user],
                                connection_hash[:password])
    @database = Rest::Database.new(@server, connection_hash[:database])
  end

  def self.database
    @database
  end

  def self.server
    @server
  end

  module WrappedDocument
    def _id
      self.__loveseat_instance_adapter[:_id].get
    end
    def _id=(other)
      self.__loveseat_instance_adapter[:_id].set(other)
    end
    def _rev
      self.__loveseat_instance_adapter[:_rev].get
    end
    def _rev=(other)
      self.__loveseat_instance_adapter[:_rev].set(other)
    end
    def _attachments
      self.__loveseat_instance_adapter[:_attachments].get
    end
    def _attachments=(other)
      self.__loveseat_instance_adapter[:_attachments].set(other)
    end
  end
end

