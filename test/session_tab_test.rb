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
    assert_equal "http://example.com/", @tab.evaluate_javascript("window.location.href")
  end

  def test_evaluate_javascript
    @tab.visit("http://example.com/")
    @tab.wait_for_load
    assert_equal 4, @tab.evaluate_javascript("2 + 2")
  end

  def test_prompt_answer
    @tab.visit("http://example.com/")
    @tab.wait_for_load
    @tab.set_prompt_answer("my answer", false)
    assert_equal "my answer", @tab.evaluate_javascript("prompt('prompt')")

    @tab.set_prompt_answer("my answer", true)
    assert_equal "", @tab.evaluate_javascript("prompt('prompt')")
  end

  def test_confirm_answer
    @tab.visit("http://example.com/")
    @tab.wait_for_load
    @tab.set_confirm_answer(true)
    assert_equal true, @tab.evaluate_javascript("confirm('prompt')")

    @tab.set_confirm_answer(false)
    assert_equal false, @tab.evaluate_javascript("confirm('prompt')")
  end

  def test_save_screenshot
    @tab.visit("http://twitter.com/")
    @tab.wait_for_load

    assert_equal "OK", @tab.save_screenshot("/tmp/twitter_screenshot.png", [1024, 1024])[:result]
    assert File.exist?("/tmp/twitter_screenshot.png")
  end

end
