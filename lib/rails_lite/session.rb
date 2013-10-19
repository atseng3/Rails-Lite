require 'json'
require 'webrick'

class Session
  attr_accessor :cookie_val
  
  def initialize(req)
    @req = req
    @cookie_val = JSON.parse((@req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }).value) || {}
  end

  def [](key)
    @cookie_val[key]
  end

  def []=(key, val)
    @cookie_val[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', @cookie_val.to_json)
  end
end
