require_relative "log_subscriber/attaching"
require_relative "log_subscriber/detaching"

module AnyLogger
  class Configuration
    class LogSubscriber
      def swap(organizer, subscriber, detach_target = nil)
        detach(organizer, detach_target)
        attach(organizer, subscriber)
      end

      def detach(organizer, detach_target = nil)
        Detaching.new(organizer, detach_target).execute
      end

      def attach(organizer, subscriber)
        Attaching.new(organizer, subscriber).execute
      end
    end
  end
end
