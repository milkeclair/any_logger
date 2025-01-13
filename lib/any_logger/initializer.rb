module AnyLogger
  class Initializer
    def self.run
      swap_default_logger
      change_subscribers
    end

    private_class_method def self.swap_default_logger
      Rails.application.config.middleware.swap(Rails::Rack::Logger, AnyLogger.config.logger)
    end

    private_class_method def self.change_subscribers
      Configuration::DEFAULT_SUBSCRIBERS.each do |key, default_subscriber|
        subscribers = AnyLogger.config.subscribers
        detachable = subscribers[key][:detachable]
        attachable = subscribers[key][:attachable]

        default_subscriber.detach_from(key) if detachable
        subscribers[key][:klass].attach_to(key) if attachable
      end
    end
  end
end
