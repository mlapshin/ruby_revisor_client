require File.join(File.dirname(__FILE__), "/../lib/revisor")
require 'test/unit'

module SetupAndTeardownOnce
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def suite
      my_suite = super
      klass = self.class

      def my_suite.run(*args)
        klass = eval(@name)
        klass.setup_once
        super(*args)
        klass.teardown_once
      end

      return my_suite
    end

    def setup_once
      # Override me in child classes
    end

    def teardown_once
      # Override me in child classes
    end

  end
end

module RevisorTestHelper
  def self.included(base)
    base.send(:include, SetupAndTeardownOnce)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
  end

  module InstanceMethods
    def create_client
      @client = Revisor::Client.new("localhost", 8080)
    end

    def test_page_url(test_page_name)
      "file://" + File.dirname(File.expand_path(__FILE__)) + "/test_pages/#{test_page_name}.html"
    end
  end

  module ClassMethods
    def setup_once
      unless Revisor.server_pid
        Revisor.server_executable = ENV['REVISOR_PATH'] || 'revisor'
        Revisor.start_server
      end
    end

    def teardown_once
      Revisor.stop_server
    end
  end
end
