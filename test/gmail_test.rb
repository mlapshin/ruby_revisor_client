require File.join(File.dirname(__FILE__), "test_helper")

class GmailTest < Test::Unit::TestCase
  include StartAndStopRevisorServer

  def setup
    create_client
    @session = @client.start_session(:gmail_test)
    @tab = @session.create_tab(:tester1)
  end

  def teardown
    @session.stop
  end

  def test_log_in
    @tab.visit("http://gmail.com/")
    @tab.wait_for_load
    @tab.e("var jquery_loaded = false; document.body.innerHTML += \"<script onload='console.log('jq loaded'); jquery_loaded = true' src='http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js\'></script>\"; ''")
    @tab.wait_for_true_evaluation("jquery_loaded == false", 500, 4)
    @tab.e("$.noConflict()");

    @tab.e("jQuery('#Email').val('revisor.tester.1@gmail.com')")
    @tab.e("jQuery('#Passwd').val('revirevi')")
    @tab.e("jQuery('#signIn').click()")

    sleep(5)
  end
end
