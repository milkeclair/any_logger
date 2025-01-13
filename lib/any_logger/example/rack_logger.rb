require "active_support/log_subscriber"

module AnyLogger
  module Example
    class RackLogger
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      ensure
        ActiveSupport::LogSubscriber.flush_all!
      end
    end
  end
end
