require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
end

task :default => ['test', 'spec']
