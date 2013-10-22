require 'erb'
require_relative 'params'
require_relative 'session'
require_relative 'flash'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params=nil)
    @req = req
    @res = res
    @params = Params.new(@req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req, @res)
  end

  def already_rendered?
    @already_built_response
  end

  def redirect_to(url)
    session.store_session(@res)
    
    @res.set_redirect(WEBrick::HTTPStatus::MovedPermanently, url)
    @already_built_response = true
  end

  def render_content(content, type)
    @res.content_type = type
    @res.body = content
    session.store_session(@res)

    @already_built_response = true
  end

  def render(template_name)
    controller_name = "#{self.class}".underscore.downcase

    contents = File.read "views/#{controller_name}/#{template_name}.html.erb"
    erb = ERB.new(contents).result(binding)

    render_content(erb, "text/html")
  end

  def invoke_action(name)
    self.send(name.to_sym)

    render(name) unless already_rendered?
  end
end
