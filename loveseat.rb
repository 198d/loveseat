$:.unshift(File.dirname(__FILE__))
load 'core_ext/hash.rb'
load 'rest/resource.rb'
load 'rest/server.rb'
load 'rest/document.rb'
load 'rest/database.rb'
load 'rest/design_document.rb'
load 'loveseat/document.rb'
load 'loveseat/document/dsl.rb'
load 'loveseat/document/support.rb'
load 'loveseat/document/instance_adapter.rb'
load 'loveseat/document/types/base.rb'
load 'loveseat/document/types/string.rb'
load 'loveseat/document/types/integer.rb'
load 'loveseat/document/types/float.rb'
load 'loveseat/document/types/date.rb'
load 'loveseat/document/types/time.rb'
load 'loveseat/document/types/array.rb'
load 'loveseat/document/types/hash.rb'
load 'loveseat/document/types/raw.rb'
load 'loveseat/design_document.rb'
load 'loveseat/design_document/dsl.rb'
load 'loveseat/design_document/support.rb'
load 'loveseat/design_document/view_row.rb'

def reload!
  load(__FILE__)
end

$server = Rest::Server.new('localhost', 5984)
$db = Rest::Database.new($server, 'loveseat')

class Parent
  Loveseat::Document.setup(self) do |s|
    s.integer :count
    s.float :rating
    s.string :name, "test"
    s.date :created, Date.today
    s.time :updated, Time.now
    s.array :collection
    s.hash :keyvalue
  end
end
$ref = Parent.new

class View
  Loveseat::DesignDocument.setup(self) do |s|
    s.view :test,
      :map => "function(doc) { emit(doc._id.split(':')[0], 1); }",
      :reduce => "function(keys, values) { return sum(values); }"
  end
end
$viewref = View.new
$viewref._rev = Loveseat::DesignDocument.get($db, $viewref._id)._rev

