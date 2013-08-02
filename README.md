# Sinatra::Croon

Allows you to add inline documentation to a Sinatra app and have a web-based
documentation browser be available to you.

## Usage

    require "sinatra/croon"

    class MyApp < Sinatra::Base
      register Sinatra::Croon
    end

## Documentation Format

    # Create an application.
    #
    # @header <header-name> header-value
    # @param <name>  the name of the application to create
    # @param [stack] the stack on which to create the application
    #
    # @request
    #   POST /apps.json
    #   name=example&stack=bamboo-ree-1.8.7
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

## Web-based browser

  Sinatra::Croon will create a route at `/docs` to display your documentation.

  See an example at [http://sinatra-croon-example.heroku.com](http://sinatra-croon-example.heroku.com)
