require "rubygems"
require "sinatra/base"

$:.unshift File.expand_path("../../lib", __FILE__)
require "sinatra/croon"

class SampleAPI < Sinatra::Base

  register Sinatra::Croon

  get "/" do
    redirect "/docs"
  end

  # A generic API call
  #
  # @request GET /generic.json
  # @response { "status": "ok" }

  get "/generic.json" do
    # do something here
  end

  # Return information about a particular application
  #
  # @request GET /apps/example.json
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

  get "/apps/:app.json" do |app|
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

  # A generic sectioned API call
  #
  # @request GET /section/generic.json
  # @response { "status": "ok" }

  get "/section/generic.json" do |app|
    # do something here
  end

end
