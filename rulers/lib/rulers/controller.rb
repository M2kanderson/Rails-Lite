require "erubis"
require "rulers/file_model"
require "rulers/view"

module Rulers
  class Controller
    include Rulers::Model
    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      text = self.send(action)
      if get_response
        status, headers, response = get_response.to_a
        [status, headers, [response].flatten]
      else
        status, headers, response = self.render(action).to_a
        [status, headers, [response.body].flatten]
      end
    end

    def self.action(act, rp = {})
      proc { |e| self.new(e).dispatch(act,rp)}
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params.merge(@routing_params)
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
