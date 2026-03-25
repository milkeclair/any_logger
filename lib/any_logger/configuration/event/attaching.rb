module AnyLogger
  class Configuration
    class Event
      class Attaching
        Attach = Data.define(:organizer, :event, :subscriber)

        def initialize(organizer, event, subscriber = nil, &block)
          @organizer  = organizer
          @event      = event
          @subscriber = subscriber
          @block      = block
          @event_name = "#{@event}.#{@organizer}"
        end

        def execute
          validate_provided_block_or_subscriber
          validate_unless_provided_block_and_subscriber
          validate_subscriber_is_callable

          push_to_subscriptions
          subscribe
        end

        private def push_to_subscriptions
          AnyLogger.config.subscriptions << Attach.new(@organizer, @event, @subscriber || @block)
        end

        private def subscribe
          # LogSubscriber#attach_toはmonotonic_subscribeなので、それに合わせる
          if @subscriber
            ActiveSupport::Notifications.monotonic_subscribe(@event_name, @subscriber.new)
          else
            ActiveSupport::Notifications.monotonic_subscribe(@event_name, &@block)
          end
        end

        private def validate_provided_block_or_subscriber
          return if @block || @subscriber

          raise ArgumentError, "Block or subscriber must be provided"
        end

        private def validate_unless_provided_block_and_subscriber
          return unless @block && @subscriber

          raise ArgumentError, "Block and subscriber cannot be provided simultaneously"
        end

        private def validate_subscriber_is_callable
          return unless @subscriber && !@subscriber.public_method_defined?(:call)

          raise NoMethodError, "Subscriber must respond to #call"
        end
      end
    end
  end
end
