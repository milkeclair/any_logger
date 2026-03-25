RSpec.describe AnyLogger::Configuration::LogSubscriber::Detaching do
  describe "#execute" do
    it "デフォルトsubscriberをdetachする" do
      detaching = described_class.new(:action_controller)
      default = instance_double(AnyLogger::Configuration::Event::Default, detach_all: nil)
      expect(ActionController::LogSubscriber).to receive(:detach_from).with(:action_controller)
      expect(AnyLogger::Configuration::Event::Default)
        .to receive(:new)
        .with(:action_controller)
        .and_return(default)

      detaching.execute

      expect(AnyLogger.config.subscriptions).to eq(
        [log_subscriber_detach(:action_controller, ActionController::LogSubscriber)]
      )
    end

    it "detach_targetを明示したときはそれを使う" do
      detach_target = Class.new do
        def self.detach_from(*) = nil
      end
      detaching = described_class.new(:action_controller, detach_target)
      default = instance_double(AnyLogger::Configuration::Event::Default, detach_all: nil)
      expect(detach_target).to receive(:detach_from).with(:action_controller)
      expect(AnyLogger::Configuration::Event::Default)
        .to receive(:new)
        .with(:action_controller)
        .and_return(default)

      detaching.execute

      expect(AnyLogger.config.subscriptions).to eq(
        [log_subscriber_detach(:action_controller, detach_target)]
      )
    end

    it "デフォルトsubscriberが見つからないときは例外を投げる" do
      detaching = described_class.new(:unknown)

      expect { detaching.execute }.to raise_error(KeyError, "unknown's default subscriber not found")
    end
  end
end
