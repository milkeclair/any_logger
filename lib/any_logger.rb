require_relative "any_logger/version"
require_relative "any_logger/configuration"
require_relative "any_logger/initializer"

module AnyLogger
  def self.configure(auto_startable: true, &block)
    block.call(config)
    start if auto_startable
  end

  def self.start
    Initializer.run
  end

  def self.config
    Configuration.instance
  end

  def self.subscribers
    config.subscribers
  end
end
