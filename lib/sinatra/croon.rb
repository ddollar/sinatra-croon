require "haml"
require "sinatra/base"

module Sinatra
  module Croon
    VERSION = "0.1.1"

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

      app.get %r{^/docs/?([\w]+)?/?$} do |section|
        pass do
          template = File.read(File.expand_path("../croon/views/docs.haml", __FILE__))
          sections = documentation.map { |doc| doc[:section] }.sort_by { |s| s.to_s }
          haml template, :locals => {
            :docs => documentation.group_by { |doc| doc[:section] },
            :current_section => sections.detect { |s| urlify_section(s) == section }
          }
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

      def documentation_base_uri
        env["REQUEST_PATH"].gsub(/#{env["PATH_INFO"]}\/?$/, '')
      end

      def urlify_section(section)
        section.to_s.downcase.gsub(' ', '_')
      end
    end

    module Parser
      def self.parse_route_documentation(filename, line)
        all_lines   = File.read(filename).split("\n").reverse
        index_start = all_lines.length - line + 1
        lines       = []
        started     = false

        all_lines[index_start..-1].each do |line|
          case line.strip[0..0]
            when '#' then
              started = true
              lines << line.strip
            when '' then
              break(2) if started
            else
              break(2)
          end
        end

        parse_comments(lines.reverse)
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
