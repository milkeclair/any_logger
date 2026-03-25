RSpec.describe AnyLogger::Configuration::Event::Attaching do
  describe "#execute" do
    it "subscriberを購読できる" do
      subscriber = Class.new do
        def call(*) = nil
      end
      attaching = described_class.new(:active_record, :sql, subscriber)

      expect(ActiveSupport::Notifications)
        .to receive(:monotonic_subscribe)
        .with("sql.active_record", an_instance_of(subscriber))

      attaching.execute

      expect(AnyLogger.config.subscriptions).to eq(
        [event_attach(:active_record, :sql, subscriber)]
      )
    end

    it "blockを購読できる" do
      block = ->(*_args) { :ok }
      attaching = described_class.new(:action_mailer, :deliver, &block)

      expect(ActiveSupport::Notifications)
        .to receive(:monotonic_subscribe) do |event_name, &received_block|
          expect(event_name).to eq("deliver.action_mailer")
          expect(received_block).to eq(block)
        end

      attaching.execute

      expect(AnyLogger.config.subscriptions).to eq(
        [event_attach(:action_mailer, :deliver, block)]
      )
    end

    it "subscriberもblockもないときは例外を投げる" do
      attaching = described_class.new(:active_record, :sql)

      expect { attaching.execute }.to raise_error(ArgumentError, "Block or subscriber must be provided")
    end

    it "subscriberとblockを同時に渡すときは例外を投げる" do
      subscriber = Class.new do
        def call(*) = nil
      end
      block = ->(*_args) { :ok }
      attaching = described_class.new(:active_record, :sql, subscriber, &block)

      expect do
        attaching.execute
      end.to raise_error(ArgumentError, "Block and subscriber cannot be provided simultaneously")
    end

    it "callを持たないsubscriberには例外を投げる" do
      subscriber = Class.new
      attaching = described_class.new(:active_record, :sql, subscriber)

      expect { attaching.execute }.to raise_error(NoMethodError, "Subscriber must respond to #call")
    end
  end
end
