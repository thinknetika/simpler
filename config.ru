require_relative 'config/environment'

use Rack::ContentType, 'text/plain'
use SimplerLogger, logdev: File.expand_path('logs/application.logs', __dir__)
run Simpler.application
