require_relative "any_logger/version"
require_relative "any_logger/configuration"
require_relative "any_logger/initializer"

module AnyLogger
  def self.configure(&block)
    config.swap_default_logger
    block.call(config)
  end

  def self.config
    Configuration.instance
  end

  def self.subscriptions
    config.subscriptions
  end
end
