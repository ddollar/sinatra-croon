$:.unshift File.expand_path("../lib", __FILE__)

require "example/sample_api"
run SampleAPI.new
