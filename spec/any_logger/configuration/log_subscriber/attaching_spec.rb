RSpec.describe AnyLogger::Configuration::LogSubscriber::Attaching do
  describe "#execute" do
    it "subscriberを購読できる" do
      subscriber = Class.new(ActiveSupport::LogSubscriber)
      attaching = described_class.new(:action_controller, subscriber)

      expect(subscriber).to receive(:attach_to).with(:action_controller)

      attaching.execute

      expect(AnyLogger.config.subscriptions).to eq(
        [log_subscriber_attach(:action_controller, subscriber)]
      )
    end
  end
end
