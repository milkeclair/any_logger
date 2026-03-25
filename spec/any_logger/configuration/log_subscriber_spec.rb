RSpec.describe AnyLogger::Configuration::LogSubscriber do
  describe "#swap" do
    it "detachしてからattachする" do
      log_subscriber = described_class.new
      subscriber = Class.new(ActiveSupport::LogSubscriber)

      expect(log_subscriber)
        .to receive(:detach).with(:action_controller, ActionController::LogSubscriber).ordered
      expect(log_subscriber)
        .to receive(:attach).with(:action_controller, subscriber).ordered

      log_subscriber.swap(:action_controller, subscriber, ActionController::LogSubscriber)
    end
  end

  describe "#detach" do
    it "Detachingを実行する" do
      log_subscriber = described_class.new
      detaching = instance_double(described_class::Detaching, execute: nil)
      expect(described_class::Detaching)
        .to receive(:new)
        .with(:action_controller, ActionController::LogSubscriber)
        .and_return(detaching)

      log_subscriber.detach(:action_controller, ActionController::LogSubscriber)
    end
  end

  describe "#attach" do
    it "Attachingを実行する" do
      log_subscriber = described_class.new
      subscriber = Class.new(ActiveSupport::LogSubscriber)
      attaching = instance_double(described_class::Attaching, execute: nil)
      expect(described_class::Attaching)
        .to receive(:new)
        .with(:action_controller, subscriber)
        .and_return(attaching)

      log_subscriber.attach(:action_controller, subscriber)
    end
  end
end
