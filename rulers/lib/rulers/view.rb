module Rulers
  class View
    def initialize(filename, locals = {})
      @template = File.read filename
      @locals = locals
    end

    def render
      eruby = Erubis::Eruby.new(@template)
      eruby.evaluate Erubis::Context.new @locals
    end
  end
end
