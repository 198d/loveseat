$:.unshift(File.dirname(__FILE__))
load 'core_ext/hash.rb'
load 'rest/resource.rb'
load 'rest/server.rb'
load 'rest/document.rb'
load 'rest/database.rb'
load 'rest/design_document.rb'
load 'stoner/document.rb'
load 'stoner/design_document.rb'
load 'stoner/document/dsl.rb'
load 'stoner/document/support.rb'
load 'stoner/design_document/dsl.rb'
load 'stoner/design_document/support.rb'
load 'stoner/design_document/view_row.rb'
load 'stoner/document/types/base.rb'
load 'stoner/document/types/string.rb'
load 'stoner/document/types/integer.rb'
load 'stoner/document/types/float.rb'
load 'stoner/document/types/date.rb'
load 'stoner/document/types/time.rb'
load 'stoner/document/types/array.rb'
load 'stoner/document/types/hash.rb'
load 'stoner/document/types/raw.rb'

def reload!
  load(__FILE__)
end

def make_server
  c = Net::HTTP.new('localhost', 5984)
  Rest::Server.new(c)
end
$server = make_server
$db = Rest::Database.new($server, 'stoner')

class Parent
  Stoner::Document.setup(self) do |s|
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
  Stoner::DesignDocument.setup(self) do |s|
    s.view :test,
      :map => "function(doc) { emit(doc._id, 1); }"
  end
end
$viewref = View.new
$viewref._id = Stoner::DesignDocument.next_id($db.server, $viewref)
$viewref._rev = Stoner::DesignDocument.get($db, $viewref._id)._rev

