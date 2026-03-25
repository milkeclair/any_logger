module AnyLogger
  class Configuration
    class Event
      class Default
        DEFAULT_ATTACHED_EVENTS = {
          action_view: [:render_template, :render_layout]
        }

        def initialize(organizer)
          @organizer = organizer
        end

        def detach_all
          return unless DEFAULT_ATTACHED_EVENTS[@organizer]

          DEFAULT_ATTACHED_EVENTS[@organizer].each do |event|
            Detaching.new(@organizer, event).execute
          end
        end
      end
    end
  end
end
