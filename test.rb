require 'rubygems'
require File.dirname(__FILE__) + "/lib/revisor/client"

client = Revisor::Client.new("localhost", 8080)
client.send_command "session.start", :session_name => "foo"
