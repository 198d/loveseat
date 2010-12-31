require 'rubygems'
require 'bundler'

Bundler.setup

require 'test/unit'
require 'fakeweb'
require 'rr'
require 'loveseat'

FakeWeb.allow_net_connect = false
class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end
