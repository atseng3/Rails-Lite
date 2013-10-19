require 'active_support/core_ext'
require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params, :req, :res, :route_params

  def initialize(req, res, route_params={})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
    @already_rendered = false
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    @already_rendered
  end

  def redirect_to(url)
    raise "double render error" if already_rendered?
    @already_built_response = true
    @res.status = '302 Found'
    @res['location'] = url.to_s
    session.store_session(@res)
  end

  def render_content(body, content_type)
    raise "double render error" if already_rendered?
    @already_built_response = true
    @res.content_type = content_type
    @res.body = body
    session.store_session(@res)
    nil
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    template = File.read("../views/#{controller_name}/#{template_name}.html.erb")
    new_erb = ERB.new(template)
    render_content(new_erb.result(binding), 'text/html')
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_rendered?
    nil
  end
end
