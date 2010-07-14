require 'rubygems'
require 'json'
require 'net/http'
require File.join(File.dirname(__FILE__), "client", "session")
require File.join(File.dirname(__FILE__), "client", "tab")

module Revisor
  class Client

    attr_accessor :host, :port

    def initialize(host, port)
      @host = host
      @port = port

      @sessions = {}
    end

    def command(command_name, params = {})
      command = { :name => command_name }.merge(params)
      json = JSON.generate(command)

      response = Net::HTTP.post_form(URI.parse("http://#{@host}:#{@port}/command"), 'command' => json)
      response_json = JSON.parse(response.body).inject({}) { |r, k| r[k.first.to_sym] = k.last; r }
    end

    def start_session(name)
      command("session.start", :session_name => name)
      @sessions[name.to_s.to_sym] = Session.new(self, name.to_s.to_sym)
    end

    def stop_session(name)
      command("session.stop", :session_name => name)
      @sessions.delete(name.to_s.to_sym)
    end

    def session(name)
      if @sessions.include?(name.to_s.to_sym)
        @sessions[name.to_s.to_sym]
      else
        raise "No session found with name #{name}"
      end
    end

    def [] (n)
      session(n)
    end

  end
end
