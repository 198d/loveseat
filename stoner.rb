$:.unshift(File.dirname(__FILE__))
load 'core_ext/hash.rb'
load 'rest/resource.rb'
load 'rest/server.rb'
load 'rest/document.rb'
load 'rest/database.rb'
load 'rest/design_document.rb'
load 'stoner/document.rb'
load 'stoner/document/support.rb'
load 'stoner/document/types/base.rb'
load 'stoner/document/types/string.rb'
load 'stoner/document/types/integer.rb'

def reload!
  load(__FILE__)
end
