require 'logger'
require 'rack'

class SimplerLogger
  def initialize(app, **options)
    @log = Logger.new(options[:logdev] || $stdout)

    @app = app
  end

  def call(env)
    status, header, body = @app.call(env)

    log_request(env, status, header)

    [status, header, body]
  end

  private

  def log_request(env, status, header)
    @log.info do
      "Request: #{request_msg(env)}\n" \
        "Handler: #{handler(env)}\n" \
        "Parameters: #{format_params(env)}\n" \
        "Response: #{response_msg(env, status, header)}"
    end
  end

  def request_msg(env)
    "#{env.fetch('REQUEST_METHOD', 'UNKNOWN')} #{env.fetch('REQUEST_URI', 'UNKNOWN')}"
  end

  def handler(env)
    controller = controller_name(env)

    action = env.fetch('simpler.action', 'UNKNOWN')
    controller ? "#{controller}##{action}" : "No Controller##{action}"
  end

  def controller_name(env)
    if env['simpler.controller']
      match = env['simpler.controller'].class.name.match('(?<name>.+Controller)')
      match ? match[:name] : 'UNKNOWN'
    else
      nil
    end
  end

  def format_params(env)
    Rack::Request.new(env).params || {}
  end

  def response_msg(env, status, header)
    status_text = Rack::Utils::HTTP_STATUS_CODES[status] || "Unknown Status"
    content_type = header['content-type'] || 'none'
    template = "#{status} #{status_text} [#{content_type}]"

    view_template = env['simpler.view_template']
    view_template ? "#{template} #{view_template}" : template
  end
end
