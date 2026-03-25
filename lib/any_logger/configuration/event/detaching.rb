module AnyLogger
  class Configuration
    class Event
      class Detaching
        Detach = Data.define(:organizer, :event)

        def initialize(organizer, event)
          @organizer  = organizer
          @event      = event
          @event_name = "#{@event}.#{@organizer}"
        end

        def execute
          push_to_subscriptions
          cancel_subscription
        end

        private def push_to_subscriptions
          AnyLogger.config.subscriptions << Detach.new(@organizer, @event)
        end

        private def cancel_subscription
          ActiveSupport::Notifications.unsubscribe(@event_name)
        end
      end
    end
  end
end
