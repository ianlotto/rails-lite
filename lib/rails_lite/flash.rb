require 'json'
require 'webrick'

class Flash
  def initialize(req, res)
    @res = res

    flash_cookie = req.cookies.select { |cookie| cookie.name == "flash" }.first

    @flash = flash_cookie.nil? ? {} : JSON.parse(flash_cookie.value)

    clear(flash_cookie) if flash_cookie
  end

  def [](key)
    @flash[key]
  end

  def []=(key, val)
    @flash[key] = val
    @res.cookies << WEBrick::Cookie.new("flash", @flash.to_json)
  end

  def clear(flash_cookie)
    flash_cookie.value = ""
  end
end