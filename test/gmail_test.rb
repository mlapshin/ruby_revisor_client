require File.join(File.dirname(__FILE__), "test_helper")

class GmailTest < Test::Unit::TestCase
  include StartAndStopRevisorServer

  def setup
    create_client
    @first_session = @client.start_session(:tester1)
    @first_tab = @first_session.create_tab(:tester1)

    @second_session = @client.start_session(:tester2)
    @second_tab = @second_session.create_tab(:tester2)

    @jquery_injection_js = <<-EOJS
    var jquery_loaded = false;

    (function () {
      var head = document.getElementsByTagName('head')[0];
      var script = document.createElement('script');
      script.type = 'text/javascript';

      script.onload = function () {
        jquery_loaded = true;
        jQuery.noConflict();
      };

      script.src = 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';
      head.appendChild(script);
    }());

    EOJS
  end

  def teardown
    @first_session.stop
    @second_session.stop
  end

  def login(tab, login, password)
    tab.visit("http://gmail.com/")
    tab.wait_for_load

    tab.e(@jquery_injection_js)
    tab.wait_for_true_evaluation("jquery_loaded == true", 500, 4)

    tab.e <<-EOE
    jQuery('#Passwd').val('#{password}');
    jQuery('#Email').val('#{login}');
    jQuery('#signIn').click();
    EOE

    assert tab.wait_for_true_evaluation("console.log(window.location); window.location.hash == '#inbox'", 6000, 10)

    tab.e(@jquery_injection_js)
    tab.wait_for_true_evaluation("jquery_loaded == true", 500, 4)
  end

  def test_mail_delivery
    login(@first_tab, 'revisor.tester.1@gmail.com', 'revirevi')
    login(@second_tab, 'revisor.tester.2@gmail.com', 'revirevi')

    x = @first_tab.e("jQuery('#canvas_frame').contents().find('span[id=:rc]').offset().left")
    y = @first_tab.e("jQuery('#canvas_frame').contents().find('span[id=:rc]').offset().top")
    @first_tab.send_mouse_event("click", x + 10, y + 10, :button => "left", :type => "click")

    sleep(1)
    assert @first_tab.wait_for_true_evaluation("jQuery('#canvas_frame').contents().find('.CoUvaf b:contains(\\'Send\\')').length == 1", 1000, 10)

    subject = "Hello from Revisor #{rand(20000)}"
    @first_tab.e <<-EOE
    jQuery('#canvas_frame').contents().find("textarea[name=to]").val("revisor.tester.2@gmail.com");
    jQuery('#canvas_frame').contents().find("input[name=subject]").val("#{subject}");
    jQuery('#canvas_frame').contents().find("iframe.editable").contents().find("body").html("Hello from Revisor");
    EOE

    x = @first_tab.e("jQuery('#canvas_frame').contents().find('b:contains(\\'Send\\')').offset().left")
    y = @first_tab.e("jQuery('#canvas_frame').contents().find('b:contains(\\'Send\\')').offset().top")
    @first_tab.send_mouse_event("click", x + 2, y + 2, :button => "left", :type => "click")

    assert @second_tab.wait_for_true_evaluation("jQuery('#canvas_frame').contents().find('*:contains(\\'#{subject}\\')').length > 0", 5000, 20)
  end
end
