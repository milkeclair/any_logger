module AnyLogger
  class Configuration
    class LogSubscriber
      class Attaching
        Attach = Data.define(:organizer, :subscriber)

        def initialize(organizer, subscriber)
          @organizer  = organizer
          @subscriber = subscriber
        end

        def execute
          push_to_subscriptions
          @subscriber.attach_to(@organizer)
        end

        private def push_to_subscriptions
          AnyLogger.config.subscriptions << Attach.new(@organizer, @subscriber)
        end
      end
    end
  end
end
