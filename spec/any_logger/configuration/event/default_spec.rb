RSpec.describe AnyLogger::Configuration::Event::Default do
  describe "#detach_all" do
    it "action_viewのデフォルトイベントを全て解除する" do
      default = described_class.new(:action_view)
      render_template = instance_double(AnyLogger::Configuration::Event::Detaching, execute: nil)
      render_layout = instance_double(AnyLogger::Configuration::Event::Detaching, execute: nil)
      expect(AnyLogger::Configuration::Event::Detaching)
        .to receive(:new)
        .with(:action_view, :render_template)
        .and_return(render_template)
      expect(AnyLogger::Configuration::Event::Detaching)
        .to receive(:new)
        .with(:action_view, :render_layout)
        .and_return(render_layout)

      default.detach_all
    end

    it "デフォルトイベントがないorganizerでは何もしない" do
      default = described_class.new(:active_record)

      expect(AnyLogger::Configuration::Event::Detaching).not_to receive(:new)

      default.detach_all
    end
  end
end
