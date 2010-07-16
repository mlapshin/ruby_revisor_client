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

    def start_server(interface = "127.0.0.1", port = 8080, delay = 1)
      if @@server_pid
        raise "Revisor server already started"
      else
        @@server_pid = fork do
          exec("#{@@server_executable} -l #{interface} -p #{port}")
        end

        sleep delay
        @@server_pid
      end
    end

    def stop_server
      if @@server_pid != nil
        Process.kill("INT", @@server_pid)
        @@server_pid = nil
      else
        raise "Revisor server is not started, so I couldn't stop it"
      end
    end
  end
end
