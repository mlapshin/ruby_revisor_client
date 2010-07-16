require File.join(File.dirname(__FILE__), "test_helper")

class SessionTabTest < Test::Unit::TestCase
  include StartAndStopRevisorServer

  def setup
    create_client
    @session = @client.start_session(:session_tab_test)
    @tab = @session.create_tab :foo
  end

  def teardown
    @session.stop
  end

  def test_session_tab_creation
    assert_not_nil @tab
    assert_equal :foo, @tab.name
  end

  def test_session_tab_creation_with_duplicate_name
    assert_raise Revisor::Client::ServerError do
      @session.create_tab :foo
    end
  end

  def test_visit_url_and_wait_for_load
    @tab.visit("http://example.com/")
    @tab.wait_for_load
    assert_equal "http://example.com/", @tab.evaluate_javascript("window.location.href")[:eval_result]
  end

end
