require File.join(File.dirname(__FILE__), "test_helper")

class SessionTest < Test::Unit::TestCase
  include StartAndStopRevisorServer

  def setup
    create_client
  end

  def test_session_start_and_stop
    session = @client.start_session(:default)
    assert_equal :default, session.name
    session.stop
  end

  def test_creation_of_session_with_duplicate_names
    session = @client.start_session(:default)

    assert_raise Revisor::Client::ServerError do
      @client.start_session(:default)
    end

    @client.stop_session(:default)
  end

  def test_setting_of_cookies
    session = @client.start_session(:cookies_test)
    session.set_cookies([{ :name => "foo", :value => "bar", :expires_at => Time.now + 3600 }], "http://www.example.com")
    puts session.get_cookies('http://www.example.com/').inspect
  end

end
