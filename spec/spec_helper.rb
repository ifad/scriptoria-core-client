require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'webmock/rspec'

SPEC_BASE = Pathname.new(__FILE__).realpath.parent

$: << SPEC_BASE.parent + 'lib'
require 'scriptoria_core/client'

RSpec::configure do |rspec|
  rspec.tty = true
  rspec.color = true
end
