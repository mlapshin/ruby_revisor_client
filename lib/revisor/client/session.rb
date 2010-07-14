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
                        :tab_name => tab_name.to_s)

        @tabs[tab_name.to_s.to_sym] = Tab.new(@client, self, tab_name.to_s.to_sym)
      end

      def destroy_tab(tab_name)
        @client.command("session.tab.destroy",
                        :session_name => @name,
                        :tab_name => tab_name.to_s)

        @tabs.delete(tab_name.to_s.to_sym)
      end

    end
  end
end
