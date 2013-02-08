$:.unshift File.expand_path("../lib", __FILE__)

require File.join(File.dirname(__FILE__), '/example/sample_api.rb')

run SampleAPI.new
