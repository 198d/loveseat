spec = Gem::Specification.new do |s|
  s.name = 'loveseat'
  s.version = '0.1.0'
  s.summary = 'Simple Couch Client / Object Document Mapper'
  s.description = %{Small, lightweight CouchDB client and object document mapper. Library is meant to be kept lean while still exposing the most powerful features of the database. Took a little inspiration from outoftime/sunspot.}
  s.files = Dir['[A-Z]*', 'lib/**/*.rb']
  s.require_paths = ['lib']
  s.author = 'John MacKenzie'
  s.homepage = 'http://198d.github.com/loveseat'
  s.email = 'john@nineteeneightd.com'

  s.add_development_dependency('fakeweb', '1.3.0')
  s.add_development_dependency('rr', '1.0.2')
  s.add_development_dependency('shoulda', '2.11.3')

  s.add_dependency('json', '1.4.6')
end
