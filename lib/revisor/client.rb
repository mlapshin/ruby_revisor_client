require 'rubygems'
require 'json'
require 'net/http'
require File.join(File.dirname(__FILE__), "client", "session")
require File.join(File.dirname(__FILE__), "client", "tab")

module Revisor
  class Client

    class ServerError < RuntimeError
    end

    attr_accessor :host, :port

    def initialize(host, port)
      @host = host
      @port = port

      @sessions = {}
    end

    def command(command_name, params = {})
      command = { :name => command_name }.merge(params)
      json = JSON.generate(command)
      puts "==> " + json
      response = Net::HTTP.post_form(URI.parse("http://#{@host}:#{@port}/command"), 'command' => json)
      response_json = JSON.parse(response.body).inject({}) { |r, k| r[k.first.to_sym] = k.last; r }

      if response_json[:result] == 'Error'
        raise ServerError, response_json[:message]
      end

      response_json
    end

    def start_session(name)
      command("session.start", :session_name => name)
      @sessions[name] = Session.new(self, name)
    end

    def stop_session(name)
      command("session.stop", :session_name => name)
      @sessions.delete(name)
    end

    def session(name)
      if @sessions.include?(name)
        @sessions[name]
      else
        raise "No session found with name #{name}"
      end
    end

    def [] (n)
      session(n)
    end

    def self.datetime_to_json(t)
      t.utc.strftime("%Y-%m-%dT%H:%M:%S")
    end

  end
end
