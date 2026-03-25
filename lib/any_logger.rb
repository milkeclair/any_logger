require "active_support"
require "active_support/notifications"
require "active_support/core_ext/string/inflections"
require "action_controller/log_subscriber"
require "active_record/log_subscriber"
require "action_view/log_subscriber"
require "action_mailer/log_subscriber"
require "action_dispatch/log_subscriber"
require "active_job/log_subscriber"
require "active_storage/log_subscriber"
require_relative "any_logger/version"
require_relative "any_logger/configuration"

module AnyLogger
  def self.configure(&block)
    config.swap_default_logger
    block.call(config)
  end

  def self.config
    Configuration.instance
  end
end
