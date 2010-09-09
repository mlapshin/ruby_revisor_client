require File.join(File.dirname(__FILE__), "test_helper")

class SessionTabTest < Test::Unit::TestCase
  include RevisorTestHelper

  def setup
    create_client
    @session = @client.start_session(:session_tab_test)
    @tab = @session.create_tab :foo
  end

  def teardown
    @session.stop
  end

  def test_session_tab_creation_and_deletion
    assert_not_nil @tab
    assert_equal :foo, @tab.name

    tab2 = @session.create_tab :bar
    assert tab2.destroy
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
    @tab.visit("http://example.com/")
    @tab.wait_for_load

    assert_equal "OK", @tab.save_screenshot("/tmp/twitter_screenshot.png", [1024, 1024])[:result]
    assert File.exist?("/tmp/twitter_screenshot.png")
  end

  def test_wait_for_condition
    @tab.visit("http://example.com/")
    @tab.wait_for_load

    # foo will be 42 after 1000 msec
    @tab.evaluate_javascript("var foo = 0; setTimeout('foo = 42', 1000)")
    assert @tab.wait_for_condition("foo == 42", 1000, 3)

    # this one will never be true
    assert_equal false, @tab.wait_for_condition("false", 1000, 3)
  end

  def test_send_mouse_click_event
    @tab.visit(test_page_url("send_mouse_click_event"))
    @tab.wait_for_load

    @tab.e("window.scrollTo(40, 40)")

    x, y = get_element_coordinates('first')
    @tab.send_mouse_event "click", x + 10, y + 10

    x, y = get_element_coordinates('second')
    @tab.send_mouse_event "dblclick", x + 10, y + 10

    # Third will be clicked only with Ctrl+Shift+Alt modifiers
    x, y = get_element_coordinates('third')
    @tab.send_mouse_event "click", x + 10, y + 10, :modifiers => ["control", "shift", "alt"]

    assert_equal [true, true, true], @tab.e("[first_clicked, second_clicked, third_clicked]")
  end

  def test_send_mouse_move_event
    @tab.visit(test_page_url("send_mouse_move_event"))
    @tab.wait_for_load

    x, y = get_element_coordinates('first')
    @tab.send_mouse_event "move", x + 10, y + 10
    @tab.send_mouse_event "move", x + 20, y + 20

    assert_equal [[x + 10, y + 10], [x + 20, y + 20]], @tab.e("mousemove_coordinates")
  end

  def test_send_key_event
    @tab.visit(test_page_url("send_key_event"))
    @tab.wait_for_load

    @tab.e("focusTextbox(1)")
    @tab.send_key_event "press", "A", "A"
    @tab.send_key_event "press", "B", "B"
    @tab.send_key_event "press", "C", "C"
    @tab.send_key_event "press", "Semicolon", "Ж"
    @tab.send_key_event "press", "E",         "У"
    @tab.send_key_event "press", "Q",         "Й"

    assert_equal "ABCЖУЙ", @tab.e("document.getElementById('textbox1').value")

    @tab.e("focusTextbox(2)")
    @tab.send_key_event "down", "A", "A", :modifiers => ['shift']

    @tab.e("focusTextbox(3)")
    @tab.send_key_event "up", "A", "A", :modifiers => ['ctrl']

    assert_equal [true, true], @tab.e("[keyWithShiftDowned, keyWithCtrlUpped]")
  end

  private

  def get_element_coordinates(element_id)
    x, y = @tab.e("[document.getElementById('#{element_id}').offsetLeft, document.getElementById('#{element_id}').offsetTop]")
    assert x.is_a?(Fixnum) && y.is_a?(Fixnum)
    return [x, y]
  end

end
