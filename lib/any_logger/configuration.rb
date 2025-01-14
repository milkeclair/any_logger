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

    Subscriber = Struct.new(:subscription, :klass, :detachable, :attachable) do
      def initialize(subscription, klass, detachable: false, attachable: false)
        super(subscription, klass, detachable, attachable)
      end
    end

    DEFAULT_SUBSCRIBERS = {
      action_controller: ActionController::LogSubscriber,
      active_record: ActiveRecord::LogSubscriber,
      action_view: ActionView::LogSubscriber,
      action_mailer: ActionMailer::LogSubscriber,
      action_dispatch: ActionDispatch::LogSubscriber,
      active_job: ActiveJob::LogSubscriber,
      active_storage: ActiveStorage::LogSubscriber
    }

    private_constant :DEFAULT_SUBSCRIBERS

    attr_reader :config

    def initialize
      @config = {
        logger: ::AnyLogger::Example::RackLogger,
        subscribers: DEFAULT_SUBSCRIBERS.map { |key, klass| Subscriber.new(key, klass) }
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

    def swap(key, klass, target_klass = nil)
      target_klass ||= DEFAULT_SUBSCRIBERS[key]

      detach(key, target_klass)
      attach(key, klass)
    end

    def detach(key, klass = nil)
      klass ||= DEFAULT_SUBSCRIBERS[key]

      target_subscriber =
        @config[:subscribers].find { it.subscription == key && it.klass == klass }

      target_subscriber.detachable = true
      target_subscriber.attachable = false
    end

    def attach(key, klass)
      @config[:subscribers] << Subscriber.new(key, klass, attachable: true)
    end
  end
end
