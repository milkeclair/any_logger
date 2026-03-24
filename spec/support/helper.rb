module Support
  module Helper
    def build_test_application
      stub_const("TestApplication", Class.new(Support::MockApplication))
      TestApplication.instance.tap do |application|
        allow(Rails).to receive(:application).and_return(application)
      end
    end

    def reset_any_logger_config
      config = AnyLogger::Configuration.instance
      config.config[:logger] = AnyLogger::Example::RackLogger
      config.subscriptions.clear
    end

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
