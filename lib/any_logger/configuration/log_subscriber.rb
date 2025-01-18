require "active_support"
require "active_support/core_ext/string/inflections"
require "action_controller/log_subscriber"
require "active_record/log_subscriber"
require "action_view/log_subscriber"
require "action_mailer/log_subscriber"
require "action_dispatch/log_subscriber"
require "active_job/log_subscriber"
require "active_storage/log_subscriber"

module AnyLogger
  class Configuration
    class LogSubscriber
      Detach = Struct.new(:organizer, :subscriber)
      Attach = Struct.new(:organizer, :subscriber)

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

      def swap(organizer, subscriber, detach_target = nil)
        @organizer = organizer
        @subscriber = subscriber
        @detach_target = detach_target || DEFAULT_SUBSCRIBERS[organizer]

        detach(organizer, detach_target)
        attach(organizer, subscriber)
      end

      def detach(organizer, detach_target = nil)
        @organizer ||= organizer
        @detach_target ||= detach_target || DEFAULT_SUBSCRIBERS[organizer]

        validate_detach_target_is_set

        push_detach_to_subscriptions
        @detach_target.detach_from(@organizer)
      end

      def attach(organizer, subscriber)
        @organizer ||= organizer
        @subscriber ||= subscriber

        push_attach_to_subscriptions
        @subscriber.attach_to(@organizer)
      end

      private def push_detach_to_subscriptions
        AnyLogger.config.subscriptions << Detach.new(@organizer, @detach_target)
      end

      private def push_attach_to_subscriptions
        AnyLogger.config.subscriptions << Attach.new(@organizer, @subscriber)
      end

      private def validate_detach_target_is_set
        raise KeyError, "#{@organizer}'s default subscriber not found" unless @detach_target
      end
    end
  end
end
