load 'core_ext/hash.rb'
load 'rest/resource.rb'
load 'rest/server.rb'
load 'rest/document.rb'
load 'rest/database.rb'
load 'rest/design_document.rb'

def reload!
  load(__FILE__)
end
