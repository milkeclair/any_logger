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
      AnyLogger.config.subscribers.each do
        detach_subscriber(it) if it.detachable
        attach_subscriber(it) if it.attachable
      end
    end

    private_class_method def self.detach_subscriber(subscriber)
      subscriber.klass.detach_from(subscriber.subscription)
    end

    private_class_method def self.attach_subscriber(subscriber)
      subscriber.klass.attach_to(subscriber.subscription)
    end
  end
end
