require_relative "event/attaching"
require_relative "event/default"
require_relative "event/detaching"

module AnyLogger
  class Configuration
    class Event
      def swap(organizer, event, subscriber = nil, &block)
        detach(organizer, event)
        attach(organizer, event, subscriber, &block)
      end

      def detach(organizer, event)
        Detaching.new(organizer, event).execute
      end

      def attach(organizer, event, subscriber = nil, &block)
        Attaching.new(organizer, event, subscriber, &block).execute
      end
    end
  end
end
