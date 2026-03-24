module Support
  module Helper
    def log_subscriber_detach(...)
      AnyLogger::Configuration::LogSubscriber::Detaching::Detach.new(...)
    end

    def log_subscriber_attach(...)
      AnyLogger::Configuration::LogSubscriber::Attaching::Attach.new(...)
    end

    def event_detach(...)
      AnyLogger::Configuration::Event::Detaching::Detach.new(...)
    end

    def event_attach(...)
      AnyLogger::Configuration::Event::Attaching::Attach.new(...)
    end
  end
end
