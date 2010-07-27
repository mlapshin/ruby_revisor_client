require File.join(File.dirname(__FILE__), "test_helper")

class GmailTest < Test::Unit::TestCase
  include StartAndStopRevisorServer

  def setup
    create_client
    @session = @client.start_session(:gmail_test)
    @tab = @session.create_tab(:tester1)

    @jquery_injection_js = <<-EOJS
    var jquery_loaded = false;

    (function () {
      var head = document.getElementsByTagName('head')[0];
      var script = document.createElement('script');
      script.type = 'text/javascript';

      script.onload = function () {
        jquery_loaded = true;
      };

      script.src = 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';
      head.appendChild(script);
    }());

    EOJS
  end

  def teardown
    @session.stop
  end

  def test_log_in
    @tab.visit("http://gmail.com/")
    @tab.wait_for_load
    @tab.e(@jquery_injection_js)
    @tab.wait_for_true_evaluation("jquery_loaded == true", 500, 4)

    @tab.e <<-EOE
    jQuery('#Passwd').val('revirevi');
    jQuery('#Email').val('revisor.tester.1@gmail.com');
    jQuery('#signIn').click();
    EOE

    @tab.wait_for_load
    puts @tab.e("jQuery('#:rc').attr('id')")
  end
end
