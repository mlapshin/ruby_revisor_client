require File.join(File.dirname(__FILE__), "revisor", "client")

module Revisor

  @@server_executable = "revisor"

  def self.server_executable
    @@server_executable
  end

  def self.server_executable=(e)
    @@server_executable = e
  end

  def self.server_pid
    @@server_pid
  end

  def self.start_server(interface = "127.0.0.1", port = 8080)
    @@server_pid = fork do
      exec("#{@@server_executable} -l #{interface} -p #{port}")
    end

    sleep 3
  end

  def self.stop_server
    Process.kill("INT", @@server_pid)
  end
end
