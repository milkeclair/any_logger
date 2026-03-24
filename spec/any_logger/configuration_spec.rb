RSpec.describe AnyLogger::Configuration do
  describe "::instance" do
    it "デフォルトの設定を持つ" do
      config = AnyLogger::Configuration.instance

      expect(config.logger).to eq(AnyLogger::Example::RackLogger)
      expect(config.subscriptions).to eq([])
    end
  end

  describe "#logger=" do
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

    it "ミドルウェアを差し替える" do
      application = build_test_application
      fork = ActionDispatch::MiddlewareStack.new
      config = AnyLogger::Configuration.instance

      config.swap_default_logger
      config.logger = custom_logger
      application.config.middleware.merge_into(fork)
      fork_middlewares = fork.map(&:klass)

      expect(fork_middlewares).to include(custom_logger)
      expect(fork_middlewares).not_to include(Rails::Rack::Logger)
      expect(config.logger).to eq(custom_logger)
    end
  end

  describe "#swap_default_logger" do
    it "デフォルトのロガーを差し替える" do
      application = build_test_application
      fork = ActionDispatch::MiddlewareStack.new
      config = AnyLogger::Configuration.instance

      config.swap_default_logger
      application.config.middleware.merge_into(fork)
      fork_middlewares = fork.map(&:klass)

      expect(fork_middlewares).to include(AnyLogger::Example::RackLogger)
      expect(fork_middlewares).not_to include(Rails::Rack::Logger)
    end
  end

  describe "#logger" do
    it "現在のロガーを返す" do
      config = AnyLogger::Configuration.instance

      expect(config.logger).to eq(AnyLogger::Example::RackLogger)
    end
  end

  describe "#subscriptions" do
    it "現在のサブスクリプションを返す" do
      config = AnyLogger::Configuration.instance
      config.subscriptions.push "test_subscription"

      expect(config.subscriptions).to eq(["test_subscription"])
    end
  end

  describe "#subscriber" do
    it "LogSubscriberのインスタンスを返す" do
      config = AnyLogger::Configuration.instance

      expect(config.subscriber).to be_a(AnyLogger::Configuration::LogSubscriber)
    end
  end

  describe "#event" do
    it "Eventのインスタンスを返す" do
      config = AnyLogger::Configuration.instance

      expect(config.event).to be_a(AnyLogger::Configuration::Event)
    end
  end

  describe "#swap" do
    it "subscriberのswapを呼び出す" do
      config = AnyLogger::Configuration.instance
      subscriber = instance_double(AnyLogger::Configuration::LogSubscriber)
      allow(config).to receive(:subscriber).and_return(subscriber)
      expect(subscriber).to receive(:swap).with(:foo, :bar)

      config.swap(:foo, :bar)
    end
  end

  describe "#detach" do
    it "subscriberのdetachを呼び出す" do
      config = AnyLogger::Configuration.instance
      subscriber = instance_double(AnyLogger::Configuration::LogSubscriber)
      allow(config).to receive(:subscriber).and_return(subscriber)
      expect(subscriber).to receive(:detach).with(:foo)

      config.detach(:foo)
    end
  end

  describe "#attach" do
    it "subscriberのattachを呼び出す" do
      config = AnyLogger::Configuration.instance
      block = -> {}
      subscriber = instance_double(AnyLogger::Configuration::LogSubscriber)
      allow(config).to receive(:subscriber).and_return(subscriber)
      expect(subscriber).to receive(:attach).with(:foo, :bar)

      config.attach(:foo, :bar, &block)
    end
  end
end
