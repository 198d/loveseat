spec = Gem::Specification.new do |s|
  s.name = 'loveseat'
  s.version = '0.1.0'
  s.summary = 'Lightweight CouchDB'
  s.description = %{Straight-forward, lightweight CouchDB client library and document mapper.}
  s.files = Dir['lib/**/*.rb']
  s.require_paths = ['lib']
  s.author = 'John MacKenzie'
  s.homepage = 'http://www.nineteeneightd.com'
  s.email = 'john@nineteeneightd.com'

  s.add_dependency('json', '1.4.6')
end
