require "singleton"
require_relative "example/rack_logger"
require_relative "configuration/log_subscriber"

module AnyLogger
  class Configuration
    include Singleton

    attr_reader :config

    def initialize
      @config = {
        logger: ::AnyLogger::Example::RackLogger,
        subscriptions: []
      }
    end

    def logger
      @config[:logger]
    end

    def logger=(klass)
      @config[:logger] = klass
    end

    def subscriptions
      @config[:subscriptions]
    end

    def subscriber
      LogSubscriber.new
    end
  end
end
