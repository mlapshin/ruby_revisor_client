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
        @client.command("session.tab.visit", :url => url)
      end

      def wait_for_load(timeout = 0)
        @client.command("session.tab.wait_for_load", :timeout => timeout)
      end

      def set_confirm_answer(answer)
        @client.command("session.tab.set_confirm_answer", :answer => answer)
      end

      def set_prompt_answer(answer, cancelled)
        @client.command("session.tab.set_prompt_answer",
                        :answer => answer,
                        :cancelled => cancelled)
      end

      def evaluate_javascript(script)
        @client.command("session.tab.evaluate_javascript",
                        :script => script)
      end

    end
  end
end
