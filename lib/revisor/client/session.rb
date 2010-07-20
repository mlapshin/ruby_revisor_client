module Revisor
  class Client
    class Session
      attr_reader :client, :name

      def initialize(client, name)
        @client = client
        @name = name
        @tabs = {}
      end

      def stop
        @client.stop_session(self.name)
      end

      def create_tab(tab_name)
        @client.command("session.tab.create",
                        :session_name => @name,
                        :tab_name => tab_name)

        @tabs[tab_name] = Tab.new(self, tab_name)
      end

      def destroy_tab(tab_name)
        @client.command("session.tab.destroy",
                        :session_name => @name,
                        :tab_name => tab_name)

        @tabs.delete(tab_name)
      end

      def set_cookies(cookies, default_url)
        @client.command("session.set_cookies",
                        :session_name => name,
                        :cookies => cookies,
                        :default_url => default_url)
      end

    end
  end
end
