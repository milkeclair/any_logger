require "active_support/notifications"

module AnyLogger
  class Configuration
    class Event
      Detach = Struct.new(:organizer, :event)
      Attach = Struct.new(:organizer, :event, :subscriber)

      def swap(organizer, event, subscriber = nil, &block)
        @organizer = organizer
        @event = event
        @subscriber = subscriber
        @block = block

        detach(organizer, event)
        attach(organizer, event, subscriber, &block)
      end

      def detach(organizer, event)
        @organizer ||= organizer
        @event ||= event

        push_detach_to_subscriptions
        ActiveSupport::Notifications.unsubscribe(event_name)
      end

      def attach(organizer, event, subscriber = nil, &block)
        @organizer ||= organizer
        @event ||= event
        @subscriber ||= subscriber
        @block ||= block

        validate_provided_block_or_subscriber
        validate_unless_provided_block_and_subscriber
        validate_subscriber_is_callable

        push_attach_to_subscriptions
        # LogSubscriber#attach_toはmonotonic_subscribeなので、それに合わせる
        ActiveSupport::Notifications.monotonic_subscribe(event_name, subscriber.new, &block)
      end

      private def event_name
        "#{@event}.#{@organizer}"
      end

      private def push_detach_to_subscriptions
        AnyLogger.config.subscriptions << Detach.new(@organizer, @event)
      end

      private def push_attach_to_subscriptions
        AnyLogger.config.subscriptions << Attach.new(@organizer, @event, @subscriber || @block)
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
