require_relative "any_logger/version"
require_relative "any_logger/configuration"
require_relative "any_logger/initializer"

module AnyLogger
  def self.configure(&block)
    block.call(config)
  end

  def self.start
    Initializer.run
  end

  def self.config
    Configuration.instance
  end

  def self.subscribers
    config.config[:subscribers]
  end
end
