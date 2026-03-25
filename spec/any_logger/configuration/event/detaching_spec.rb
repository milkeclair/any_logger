RSpec.describe AnyLogger::Configuration::Event::Detaching do
  describe "#execute" do
    it "購読解除できる" do
      detaching = described_class.new(:active_record, :sql)

      expect(ActiveSupport::Notifications).to receive(:unsubscribe).with("sql.active_record")

      detaching.execute

      expect(AnyLogger.config.subscriptions).to eq(
        [event_detach(:active_record, :sql)]
      )
    end
  end
end
