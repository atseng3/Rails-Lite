require 'active_support/core_ext'
require 'webrick'
# require 'rails_lite'

server = WEBrick::HTTPServer.new :Port => 8080
trap ('INT') { server.shutdown }

server.mount_proc '/' do |req, res|
  res.content_type = 'text/text'
  res.body = req.path
  p "req is: #{req}"
  p "res is: #{res}"
end

server.start