require "active_support/log_subscriber"
require "rack/utils"

module AnyLogger
  module Example
    class ControllerSubscriber < ActiveSupport::LogSubscriber
      UNNECESSARY_PATHS = ["/favicon.ico"]

      REDIRECT_CODES = [:moved_permanently, :found, :see_other, :temporary_redirect, :permanent_redirect]

      private_constant :UNNECESSARY_PATHS, :REDIRECT_CODES

      def process_action(event)
        @event = event
        @payload = event.payload
        @headers = @payload[:response].headers.symbolize_keys if @payload[:response]&.headers

        return if match_unnecessary_path?

        info { formatted_message }
      end

      # @example
      #
      #   [GET] HogeController#index for: 127.0.0.1 at: 2025-01-01 00:00:00 +0900
      #     path: "/hoge?foo=bar"
      #     status: 200 in 100ms (view: 50ms | db: 50ms)
      #     params: {"foo" => "bar"}
      #     redirect: "/fuga"
      private def formatted_message
        <<~MESSAGE

          #{l_method} #{l_action} #{l_for} #{l_at}
            #{l_path}
            #{l_status} #{l_duration} (#{l_view_runtime} | #{l_db_runtime})
            #{"#{l_params}\n" if @payload[:params].present?}#{l_redirect if @headers[:location].present?}
        MESSAGE
      end

      private def match_unnecessary_path?
        UNNECESSARY_PATHS.include?(@payload[:path])
      end

      private def l_method
        "[#{@payload[:method].upcase}]"
      end

      private def l_action
        "#{@payload[:controller]}##{@payload[:action]}"
      end

      private def l_for
        "for: #{@payload[:request].remote_ip}"
      end

      private def l_at
        "at: #{conversion_event_time_to_datetime}"
      end

      private def l_path
        "🔍 path: \"#{@payload[:path]}\""
      end

      private def l_status
        "🧱 status: #{@payload[:status]}"
      end

      private def l_duration
        "in #{@event.duration&.round(2) || 0}ms"
      end

      private def l_view_runtime
        "view: #{@payload[:view_runtime]&.round(2) || 0}ms"
      end

      private def l_db_runtime
        "db: #{@payload[:db_runtime]&.round(2) || 0}ms"
      end

      private def l_params
        @payload[:params] = except_unnecessary_params
        "📝 params: #{@payload[:params]&.inspect || {}}"
      end

      private def l_redirect
        return unless REDIRECT_CODES.any? { @payload[:status] == Rack::Utils.status_code(it) }

        ellipsised_url = ellipsis_scheme_and_authority(@headers[:location])
        "🚀 redirect: \"#{ellipsised_url}\""
      end

      private def conversion_event_time_to_datetime
        now_monotonic = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        elapsed = now_monotonic - @event.time
        now = Time.now.to_f

        Time.at((now - elapsed).to_i)
      end

      private def except_unnecessary_params
        @payload[:params].except("controller", "action")
      end

      private def ellipsis_scheme_and_authority(url)
        url.gsub(/\Ahttps?:\/\/[^\/]+/, "")
      end
    end
  end
end
