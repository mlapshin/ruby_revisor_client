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
        cmd = session_and_tab_names.merge({ :script => script, :interval => interval, :tries_count => tries_count })
        @client.command("session.tab.wait_for_true_evaluation", cmd)
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
        cmd = session_and_tab_names.merge({ :script => script })
        @client.command("session.tab.evaluate_javascript", cmd)[:eval_result]
      end

      protected

      def session_and_tab_names
        { :session_name => session.name, :tab_name => name }
      end

    end
  end
end
