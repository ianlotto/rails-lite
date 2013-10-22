require 'json'
require 'webrick'

class Session
  def initialize(req)
    cookie = req.cookies.select { |cookie| cookie.name == "_rails_lite_app" }

    @session = cookie.empty? ? {} : JSON.parse(cookie.first.value)
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new("_rails_lite_app", @session.to_json)
  end
end
