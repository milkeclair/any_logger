require "singleton"
require "active_support"
require "active_support/core_ext/string/inflections"
require "action_controller/log_subscriber"
require "active_record/log_subscriber"
require "action_view/log_subscriber"
require "action_mailer/log_subscriber"
require "action_dispatch/log_subscriber"
require "active_job/log_subscriber"
require "active_storage/log_subscriber"
require_relative "example/rack_logger"

module AnyLogger
  class Configuration
    include Singleton

    DEFAULT_SUBSCRIBERS = {
      action_controller: ActionController::LogSubscriber,
      active_record: ActiveRecord::LogSubscriber,
      action_view: ActionView::LogSubscriber,
      action_mailer: ActionMailer::LogSubscriber,
      action_dispatch: ActionDispatch::LogSubscriber,
      active_job: ActiveJob::LogSubscriber,
      active_storage: ActiveStorage::LogSubscriber
    }

    DEFAULT_SUBSCRIBER_OPTIONS = { klass: nil, detachable: false, attachable: false }

    private_constant :DEFAULT_SUBSCRIBER_OPTIONS

    attr_reader :config

    def initialize
      @config = {
        logger: ::AnyLogger::Example::RackLogger,
        subscribers: DEFAULT_SUBSCRIBERS.dup.transform_values { |k| DEFAULT_SUBSCRIBER_OPTIONS.dup.merge(klass: k) }
      }
    end

    def logger
      @config[:logger]
    end

    def logger=(klass)
      @config[:logger] = klass
    end

    def subscribers
      @config[:subscribers]
    end

    def swap(key, klass)
      return unless @config[:subscribers].key?(key)

      @config[:subscribers][key] = { klass: klass, detachable: true, attachable: true }
    end

    def detach(key, klass = nil)
      return unless @config[:subscribers].key?(key)

      @config[:subscribers][key][:detachable] = true
      @config[:subscribers][key][:klass] = klass if klass
    end

    def attach(key, klass)
      return unless @config[:subscribers].key?(key)

      @config[:subscribers][key][:attachable] = true
      @config[:subscribers][key][:klass] = klass
    end
  end
end
