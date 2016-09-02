require "erubis"
require "rulers/file_model"
require "rulers/view"

module Rulers
  class Controller
    include Rulers::Model
    def initialize(env)
      @env = env
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params
    end

    def env
      @env
    end

    def render_view(view_name, locals ={})
      ivars = instance_variables.inject({}) do |ivar_hash,ivar|
        ivar_hash[ivar[1..-1]] = instance_variable_get(ivar)
        ivar_hash
      end
      filename = File.join "./app", "views", controller_name, "#{view_name}.html.erb"
      # template = File.read filename
      # eruby = Erubis::Eruby.new(template)
      # eruby.result locals.merge(ivars)
      View.new(filename, locals.merge(ivars)).render
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")
      Rulers.to_underscore(klass)
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response
      @response
    end

    def render(*args)
      response(render_view(*args))
    end

  end
end
