require 'json'
require 'net/http'

module Revisor
  class Client

    attr_accessor :host, :port

    def initialize(host, port)
      @host = host
      @port = port
    end

    def send_command(command_name, params = {})
      command = { :name => command_name }.merge(params)
      json = JSON.generate(command)

      response = Net::HTTP.post_form(URI.parse("http://#{@host}:#{@port}/command"), 'command' => json)
      response_json = JSON.parse(response.body).inject({}) { |r, k| r[k.first.to_sym] = k.last; r }
    end

  end
end
