require "haml"
require "sinatra/base"

module Sinatra
  module Croon
    VERSION = "0.1.0"

    def self.registered(app)
      app.helpers Croon::Helpers
      @app = app

      app.get '/docs.css' do
        pass do
          content_type "text/css"
          template = File.read(File.expand_path("../croon/views/docs.sass", __FILE__))
          sass template
        end
      end

      app.get '/docs' do
        pass do
          template = File.read(File.expand_path("../croon/views/docs.haml", __FILE__))
          haml template, :locals => { :docs => documentation }
        end
      end
    end

    def self.route_added(verb, path, block)
      return if verb.to_s == "HEAD"

      route_location = caller(1).reject { |line| line =~ /sinatra\/base/ }.first
      file, line = route_location.split(':')
      doc = Croon::Parser.parse_route_documentation(file, line.to_i)

      if doc[:description]
        doc[:verb] = verb
        doc[:uri] = path
        @app.documentation << doc
      end
    end

    def documentation
      @documentation ||= []
    end

    module Helpers
      def display_code(code)
        Haml::Filters::Preserve.render(Haml::Filters::Escaped.render(code))
      end

      def documentation
        self.class.documentation
      end
    end

    module Parser
      def self.parse_route_documentation(filename, line)
        all_lines   = File.read(filename).split("\n").reverse
        index_start = all_lines.length - line + 1
        num_lines   = all_lines[index_start..-1].index { |l| !['', '#'].include?(l.strip[0..0]) }
        doc_lines   = all_lines[index_start, num_lines].reverse

        parse_comments(doc_lines)
      end

      def self.parse_comments(comments)
        key = :description

        comments.inject({}) do |parsed, comment|
          case comment.strip
            when /\A#\s*@param\s+(.+?)\s+(.+)/ then
              parsed[:params] ||= []
              required = $1[0..0] == '<'
              name = $1[1..-2]
              parsed[:params] << { :name => name, :description => $2, :required => required }
            when /\A#\s*@(\w+)\s*(.*)\Z/ then
              key = $1.to_sym
              parsed[key] ||= []
              parsed[key]  << $2 if $2
            when /\A#(.+)\Z/ then
              parsed[key] ||= []
              parsed[key]  << $1
          end
          parsed
        end.inject({}) do |flattened, (k, v)|
          case v.first
            when String then
              flattened[k] = strip_left(v.reject { |l| l.strip == "" }.join("\n"))
            else
              flattened[k] = v
          end
          flattened
        end
      end

      def self.strip_left(code)
        first_line = code.split("\n").first
        return code unless first_line
        num_spaces = first_line.match(/\A */)[0].length
        code.split("\n").map do |line|
          line[num_spaces..-1]
        end.join("\n")
      end
    end
  end

  register Croon
end
