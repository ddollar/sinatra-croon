require "rubygems"
require "rack/test"
require "rspec"
require "webrat" 
require "webrat/core/matchers"

$:.unshift "lib"

Rspec.configure do |config|
  config.color_enabled = true
end
