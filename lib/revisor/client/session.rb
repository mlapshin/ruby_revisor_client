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

      def set_cookies(cookies, url)
        cookies.each do |cookie|
          if cookie[:expires_at] && cookie[:expires_at].is_a?(Time)
            cookie[:expires_at] = Client.datetime_to_json(cookie[:expires_at])
          end
        end

        @client.command("session.set_cookies",
                        :session_name => @name,
                        :cookies => cookies,
                        :url => url)
      end

      def get_cookies(url)
        @client.command("session.get_cookies",
                        :session_name => @name,
                        :url => url)[:cookies]
      end

    end
  end
end
