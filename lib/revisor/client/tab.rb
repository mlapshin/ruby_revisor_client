module Revisor
  class Client
    class Tab

      attr_reader :session, :name, :client

      def initialize(session, name)
        @client = session.client
        @session = session
        @name = name
      end

      def visit(url)
        cmd = session_and_tab_names.merge({ :url => url })
        @client.command("session.tab.visit", cmd)
      end

      def wait_for_load(timeout = 0)
        cmd = session_and_tab_names.merge({ :timeout => timeout })
        @client.command("session.tab.wait_for_load", cmd)
      end

      def wait_for_true_evaluation(script, interval, tries_count)
        successfull = false
        step = 0

        while !successfull && step < tries_count
          result = e(script)
          puts "WTE: #{result.inspect}"
          successfull = (result == true)
          step = step + 1
          sleep(interval / 1000.0)
        end

        successfull
      end

      def set_confirm_answer(answer)
        cmd = session_and_tab_names.merge({ :answer => answer })
        @client.command("session.tab.set_confirm_answer", cmd)
      end

      def set_prompt_answer(answer, cancelled)
        cmd = session_and_tab_names.merge({ :answer => answer, :cancelled => cancelled })
        @client.command("session.tab.set_prompt_answer", cmd)
      end

      def evaluate_javascript(script)
        puts "EEE: #{script}"
        cmd = session_and_tab_names.merge({ :script => script })
        @client.command("session.tab.evaluate_javascript", cmd)[:eval_result]
      end

      alias :e :evaluate_javascript

      def save_screenshot(file_name, size = nil)
        cmd = session_and_tab_names.merge({ :file_name => file_name })

        if size
          cmd[:viewport_width] = size.first.to_i
          cmd[:viewport_height] = size.last.to_i
        end

        @client.command("session.tab.save_screenshot", cmd)
      end

      def send_mouse_event(type, x, y, options = {})
        options[:button] ||= "left" if type == "click" || type == "dblclick"
        cmd = session_and_tab_names.merge(:x => x, :y => y, :type => type).merge(options)
        @client.command("session.tab.send_mouse_event", cmd)
      end

      protected

      def session_and_tab_names
        { :session_name => session.name, :tab_name => name }
      end

    end
  end
end
