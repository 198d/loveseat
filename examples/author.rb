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
  setup do
    string :name
    date :birth
    date :death
    hash :hometown
    array :works
  end
end

class AuthorUtility < Loveseat::ViewSet
  setup do
    view :all_works,
      :map => "function(doc) { var works = (doc['works'] || []); \
                for(work in works) { emit(doc._id, works[work]); } }"
  end
end

sam = Author.new
sam.name = 'Samuel Taylor Coleridge'

# Will _cast_ these things to Date objects
# by passing them through Date.parse
sam.birth = '1772-10-21'
sam.death = '1834-07-25'

# Could be made to act more like an embeded
# document and allow something like a Hometown
# object to be used
sam.hometown = {
  'city' => 'Ottery St. Mary',
  'state' => 'Devon',
  'country' => 'England'
}

# Could be expanded to type check the elements of
# the array to guarantee consistency
sam.works = [
  'Rime of the Ancient Mariner',
  'Christabel',
  'Kubla Khan'
]

# sam.put()   => #<Author>
# sam._id #   => "Author:<uuid>"
# sam._rev #  => "1:<hash>"

# Guarantees the version of the design document we
# have in this scope is the one in database
AuthorUtility.latest!

AuthorUtility.view(:all_works) # => [#<Loveseat::DesignDocument::ViewRow>,
                                     #<Loveseat::DesignDocument::ViewRow>,
                                     #<Loveseat::DesignDocument::ViewRow>]


