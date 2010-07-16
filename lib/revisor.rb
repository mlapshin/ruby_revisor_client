require File.join(File.dirname(__FILE__), "revisor", "client")

module Revisor

  @@server_executable = "revisor"
  @@server_pid = nil

  class << self
    def server_executable
      @@server_executable
    end

    def server_executable=(e)
      @@server_executable = e
    end

    def server_pid
      @@server_pid
    end

    def start_server(interface = "127.0.0.1", port = 8080, delay = 3)
      @@server_pid = fork do
        exec("#{@@server_executable} -l #{interface} -p #{port}")
      end

      sleep delay
    end

    def stop_server
      Process.kill("INT", @@server_pid)
      @@server_pid = 0
    end
  end
end
