require "singleton"
require_relative "example/rack_logger"
require_relative "configuration/event"
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

    def logger=(klass)
      Rails.application.config.middleware.swap(logger, klass)
      @config[:logger] = klass
    end

    def swap_default_logger
      Rails.application.config.middleware.swap(Rails::Rack::Logger, logger)
    end

    def logger = @config[:logger]
    def subscriptions = @config[:subscriptions]

    def subscriber = LogSubscriber.new
    def event = Event.new

    def swap(...) = subscriber.swap(...)
    def detach(...) = subscriber.detach(...)
    def attach(...) = subscriber.attach(...)
  end
end
