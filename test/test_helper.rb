require 'rubygems'
require 'test/unit'
require 'fakeweb'
require 'rr'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'loveseat'

FakeWeb.allow_net_connect = false
class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end
