module AnyLogger
  class Configuration
    class LogSubscriber
      class Detaching
        Detach = Data.define(:organizer, :subscriber)

        DEFAULT_SUBSCRIBERS = {
          action_controller: ActionController::LogSubscriber,
          active_record: ActiveRecord::LogSubscriber,
          action_view: ActionView::LogSubscriber,
          action_mailer: ActionMailer::LogSubscriber,
          action_dispatch: ActionDispatch::LogSubscriber,
          active_job: ActiveJob::LogSubscriber,
          active_storage: ActiveStorage::LogSubscriber
        }

        def initialize(organizer, detach_target = nil)
          @organizer     = organizer
          @detach_target = detach_target || DEFAULT_SUBSCRIBERS[@organizer]
        end

        def execute
          validate_detach_target_is_set

          push_to_subscriptions
          @detach_target.detach_from(@organizer)
          Event::Default.new(@organizer).detach_all
        end

        private def push_to_subscriptions
          AnyLogger.config.subscriptions << Detach.new(@organizer, @detach_target)
        end

        private def validate_detach_target_is_set
          raise KeyError, "#{@organizer}'s default subscriber not found" unless @detach_target
        end
      end
    end
  end
end
