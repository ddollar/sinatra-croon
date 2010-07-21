require "spec_helper"
require "sinatra/base"
require "sinatra/croon"

class MockSinatraApp < Sinatra::Base
  register Sinatra::Croon

  # Show an application.
  #
  # @request GET /apps.json
  # @response { "status" : "ok" }

  get "/apps.json" do
    # do something here
  end

  # Create an application.
  #
  # @param <name>  the name of the application to create
  # @param [stack] the stack on which to create the application
  #
  # @request
  #   POST /apps.json
  #   name=example&stack=bamboo-ree-1.8.7
  #
  # @response
  #   {
  #     "id":         1,
  #     "name":       "example",
  #     "owner":      "user@example.org",
  #     "created_at": "Sat Jan 01 00:00:00 UTC 2000",
  #     "stack":      "bamboo-ree-1.8.7",
  #     "slug_size":  1000000,
  #     "repo_size":  500000,
  #     "dynos":      1,
  #     "workers":    0
  #   }

  post "/apps.json" do
    # do something here
  end
end

describe Sinatra::Croon do
  include Rack::Test::Methods
  include Webrat::Matchers

  let(:app) { MockSinatraApp.new }

  it "can set a description" do
    get "/docs"
    last_response.should have_selector(".description", :content => "Show an application.")
    last_response.should have_selector(".description", :content => "Create an application.")
  end

  it "can set params" do
    get "/docs"
    last_response.should have_selector(".param") do |param|
      param.should have_selector(".type.required")
      param.should have_selector(".name", :content => "name")
      param.should have_selector(".description", :content => "the name of the application to create")
    end
    last_response.should have_selector(".param") do |param|
      param.should have_selector(".name", :content => "stack")
      param.should have_selector(".description", :content => "the stack on which to create the application")
    end
  end

  it "can set a request" do
    get "/docs"
    last_response.should have_selector(".request", :content => "GET /apps.json")
  end

  it "can set a response" do
    get "/docs"
    last_response.should have_selector(".response", :content => '{ "status" : "ok" }')
  end

  it "has a default style" do
    get "/docs.css"
    last_response.should =~ /\.response/
  end

end
