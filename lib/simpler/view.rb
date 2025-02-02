require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      return @env['simpler.format'][:plain] unless @env['simpler.format'].nil?

      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      view_template = "#{path}.html.erb"
      @env['simpler.view_template'] = view_template
      Simpler.root.join(VIEW_BASE_PATH, view_template)
    end

  end
end
