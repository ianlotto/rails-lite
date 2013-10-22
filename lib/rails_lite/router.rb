class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    @http_method == req.request_method.downcase.to_sym && @pattern =~ req.path
  end

  def run(req, res)
    url_params = {}
    match_data = @pattern.match(req.path)

    match_data.names.each do |name|
      url_params[name.to_sym] = match_data[name]
    end

    @controller_class.new(req, res, url_params).invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  [:get, :post, :put, :delete].each do |http_method|

    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, __callee__, controller_class, action_name)
    end
  end

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end

    nil
  end

  def run(req, res)
    matched_route = self.match(req)

    if matched_route
      matched_route.run(req, res)
    else
      res.status = 404
    end
  end
end