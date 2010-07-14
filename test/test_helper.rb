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
