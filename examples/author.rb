$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'loveseat'

Loveseat::Model.connection = {
  :host => 'localhost',
  :port => 5984,
  :user => 'admin',
  :password => 'admin',
  :database => 'authors'
}

# Could create the database with this
# if it does not exist
# Loveseat::Model.database.put

class Author < Loveseat::Model
  class Hometown < Loveseat::Model
    setup :abstract => true do
      string :city
      string :state
      string :country
    end
  end

  class Work < Loveseat::Model
    setup :abstract => true do
      string :title
      date :published
    end
  end

  setup do
    string :name
    time :birth
    time :death
    embeded :hometown, Hometown
    embeded :works, Work
    timestamped
  end
end

class AuthorUtility < Loveseat::ViewSet
  setup do
    view :all_works,
      :map => "function(doc) { var works = (doc['works'] || []); \
                for(work in works) { emit(doc._id, works[work]); } }"
  end
end
