require "rulers/version"
require "rulers/routing"
require 'rulers/array'

module Rulers
  class Application
    def call(env)
      'echo debug > debug.txt';
      if env['PATH_INFO'] == '/favicon.ico'
            return [404,
              {'Content-Type' => 'text/html'}, []]
      end
      if env['PATH_INFO'] == '/'
        controller = Object.const_get('QuotesController').new(env)
        text = controller.send('a_quote')
      else
        klass, act = get_controller_and_action(env)
        controller = klass.new(env)
        text = controller.send(act)
      end
      [200, {'Content-Type' => 'text/html'},
        [text]]
    end
  end
  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end
end
