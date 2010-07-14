require File.join(File.dirname(__FILE__), "revisor", "client")

module Revisor

  @@server_executable = "revisor"

  def self.server_executable
    @@server_executable
  end

  def self.server_executable=(e)
    @@server_executable = e
  end

  def self.current_server
    @@current_server
  end

  def self.start_server(interface = "127.0.0.1", port = 8080)
    @@current_server = IO.popen("#{@@server_executable} -l #{interface} -p #{port}")
    @@current_server.pid
  end

  def self.stop_server
    Process.kill("INT", @@current_server.pid)
  end
end
