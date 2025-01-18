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

    def swap_default_logger
      Rails.application.config.middleware.swap(Rails::Rack::Logger, logger)
    end

    def subscriptions
      @config[:subscriptions]
    end

    def subscriber
      LogSubscriber.new
    end

    def swap(...)
      subscriber.swap(...)
    end

    def detach(...)
      subscriber.detach(...)
    end

    def attach(...)
      subscriber.attach(...)
    end
  end
end
