RSpec.describe AnyLogger do
  it "バージョンがある" do
    expect(AnyLogger::VERSION).not_to be_nil
  end

  describe "::configure" do
    let!(:custom_logger) do
      Class.new do
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        end
      end
    end

    it "ブロックで設定できる" do
      stub_const("TestApplication", Class.new(Support::MockApplication))
      application = TestApplication.instance
      fork = ActionDispatch::MiddlewareStack.new
      sql_event = ->(*_args) { "sql_event" }
      deliver_event = ->(*_args) { "deliver_event" }

      AnyLogger.configure do |config|
        config.logger = custom_logger

        config.swap :action_controller, AnyLogger::Example::ControllerSubscriber
        config.subscriber.detach :active_job

        config.event.swap :active_record, :sql, &sql_event
        config.event.attach :action_mailer, :deliver, &deliver_event
      end

      application.config.middleware.merge_into(fork)
      fork_middlewares = fork.map(&:klass)
      subscriptions = AnyLogger.config.subscriptions

      expect(fork_middlewares).to include(custom_logger)
      expect(fork_middlewares).not_to include(Rails::Rack::Logger)
      expect(AnyLogger.config.logger).to eq(custom_logger)
      expect(subscriptions).to include(
        # swap
        log_subscriber_detach(:action_controller, ActionController::LogSubscriber),
        log_subscriber_attach(:action_controller, AnyLogger::Example::ControllerSubscriber),
        # detach
        log_subscriber_detach(:active_job, ActiveJob::LogSubscriber),
        # swap
        event_detach(:active_record, :sql),
        event_attach(:active_record, :sql, sql_event),
        # attach
        event_attach(:action_mailer, :deliver, deliver_event)
      )
    end
  end

  describe "::config" do
    it "Configurationのインスタンスを返す" do
      expect(AnyLogger.config).to be_an_instance_of(AnyLogger::Configuration)
    end
  end
end
