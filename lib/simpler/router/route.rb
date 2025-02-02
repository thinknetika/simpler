module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @controller = controller
        @action = action
        @path_regex = build_path_regex(path)
        @params = {}
      end

      def match?(method, path)
        @method == method && @path_regex.match(path)
      end

      def add_params(path)
        match = path.scan(/^\/(\w+)\/(\d+)$/).flatten

        @params[:id] = match[1].to_i
      end

      private

      def build_path_regex(path)
        regex_path = path.gsub(/:\w+/, '([^/]+)')
        Regexp.new("^#{regex_path}/?$")
      end
    end
  end
end
