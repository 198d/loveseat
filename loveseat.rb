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
load 'loveseat/document/property/base.rb'
load 'loveseat/document/property/string.rb'
load 'loveseat/document/property/integer.rb'
load 'loveseat/document/property/float.rb'
load 'loveseat/document/property/date.rb'
load 'loveseat/document/property/time.rb'
load 'loveseat/document/property/array.rb'
load 'loveseat/document/property/hash.rb'
load 'loveseat/document/property/raw.rb'
load 'loveseat/design_document.rb'
load 'loveseat/design_document/dsl.rb'
load 'loveseat/design_document/support.rb'
load 'loveseat/design_document/view_row.rb'
load 'loveseat/model.rb'
load 'loveseat/view_set.rb'

def reload!
  load(__FILE__)
end

Loveseat::Model.connection = {
  :host => 'localhost',
  :port => 5984,
  :database => 'loveseat'
}

$server = Loveseat::Model.server
$db = Loveseat::Model.database

class Parent < Loveseat::Model
  setup do
    integer :count
    float :rating
    string :name, "test"
    date :created, Date.today
    time :updated, Time.now
    array :collection
    hash :keyvalue
  end
end
$ref = Parent.new
$ref2 = Parent.new

class View < Loveseat::ViewSet
  setup do
    view :test,
      :map => "function(doc) { emit(doc._id.split(':')[0], 1); }",
      :reduce => "function(keys, values) { return sum(values); }"
  end
end

