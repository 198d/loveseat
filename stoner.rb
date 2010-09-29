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
load 'stoner/document/types/float.rb'
load 'stoner/document/types/date.rb'
load 'stoner/document/types/time.rb'

def reload!
  load(__FILE__)
end

def make_implementation
  klass = Class.new
  Stoner::Document.setup(klass) do |s|
    s.integer :count, 0
    s.float :rating, 0
    s.string :name, "test"
    s.date :created, Date.today
    s.time :updated, Time.now
  end
  klass.instance_eval do
    def name
      'Reference'
    end
  end
  klass.new
end
$ref = make_implementation

def make_server
  c = Net::HTTP.new('localhost', 5984)
  Rest::Server.new(c)
end
$server = make_server
$db = Rest::Database.new($server, 'stoner')
