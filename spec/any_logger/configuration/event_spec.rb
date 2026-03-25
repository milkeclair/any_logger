RSpec.describe AnyLogger::Configuration::Event do
  describe "#swap" do
    it "detachしてからattachする" do
      event = described_class.new
      expect(event).to receive(:detach).with(:active_record, :sql).ordered
      expect(event).to receive(:attach).with(:active_record, :sql, nil).ordered

      event.swap(:active_record, :sql)
    end
  end

  describe "#detach" do
    it "Detachingを実行する" do
      event = described_class.new
      detaching = instance_double(described_class::Detaching, execute: nil)
      expect(described_class::Detaching)
        .to receive(:new)
        .with(:active_record, :sql)
        .and_return(detaching)

      event.detach(:active_record, :sql)
    end
  end

  describe "#attach" do
    it "Attachingを実行する" do
      event = described_class.new
      subscriber = Class.new do
        def call(*) = nil
      end
      attaching = instance_double(described_class::Attaching, execute: nil)
      expect(described_class::Attaching)
        .to receive(:new)
        .with(:active_record, :sql, subscriber)
        .and_return(attaching)

      event.attach(:active_record, :sql, subscriber)
    end
  end
end
