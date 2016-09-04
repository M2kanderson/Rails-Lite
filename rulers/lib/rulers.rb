require "rulers/version"
require "rulers/routing"
require 'rulers/array'
require 'rulers/util'
require 'rulers/dependencies'
require 'rulers/controller'
require 'rulers/file_model'

module Rulers
  class Application
    def call(env)
      'echo debug > debug.txt';
      if env['PATH_INFO'] == '/favicon.ico'
            return [404,
              {'Content-Type' => 'text/html'}, []]
      end
      self.get_rack_app(env).call(env)


      # if env['PATH_INFO'] == '/'
      #   controller = Object.const_get('QuotesController').new(env)
      #   act = 'a_quote'
      #   text = controller.send(act)
      # else
      #   klass, act = get_controller_and_action(env)
      #   controller = klass.new(env)
      #   text = controller.send(act)
      # end
      # if controller.get_response
      #   status, headers, response = controller.get_response.to_a
      #   [status, headers, [response.body].flatten]
      # else
      #   status, headers, response = controller.render(act).to_a
      #   [status, headers, [response.body].flatten]
      # end

    end
  end

end
