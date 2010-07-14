require File.join(File.dirname(__FILE__), "test_helper")

class RevisorTest < Test::Unit::TestCase
  include SetupAndTeardownOnce

  def self.setup_once
    Revisor.server_executable = ENV['REVISOR_PATH'] || 'revisor'
    Revisor.start_server
  end

  def self.teardown_once
    Revisor.stop_server
  end

  def setup
    @client = Revisor::Client.new("localhost", 8080)
  end

  def test_session_start
    session = @client.start_session("default")
  end
end
