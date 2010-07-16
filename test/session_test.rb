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

end
