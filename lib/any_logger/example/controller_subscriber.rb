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
        e = formatted_log_details
        # ヒアドキュメントだとparamsとredirectの有無で改行の入り方が変わってしまうので、配列を結合する方法を採用
        lines = []
        lines << ""
        lines << "[#{e[:method]}] #{e[:controller]}##{e[:action]} for: #{e[:ip]} at: #{e[:datetime]}"
        lines << "  🔍 path: \"#{e[:path]}\""
        lines << "  🧱 status: #{e[:status]} in #{e[:duration]}ms " \
                 "(view: #{e[:view_runtime]}ms | db: #{e[:db_runtime]}ms)"
        lines << "  📝 params: #{e[:params]}" if @payload[:params].present?
        lines << "  🚀 redirect: \"#{e[:redirect_to]}\"" if @headers[:location].present?
        lines.join("\n")
      end

      private def match_unnecessary_path?
        UNNECESSARY_PATHS.include?(@payload[:path])
      end

      private def formatted_log_details
        {
          method: @payload[:method].upcase,
          controller: @payload[:controller],
          action: @payload[:action],
          ip: @payload[:request].remote_ip,
          datetime: conversion_event_time_to_datetime,
          path: @payload[:path],
          status: @payload[:status],
          duration: round_value(@event.duration),
          view_runtime: round_value(@payload[:view_runtime]),
          db_runtime: round_value(@payload[:db_runtime]),
          params: expect_unnecessary_params || {},
          redirect_to: formatted_redirect_location
        }
      end

      private def formatted_redirect_location
        return unless REDIRECT_CODES.any? { @payload[:status] == Rack::Utils.status_code(it) }

        ellipsis_scheme_and_authority(@headers[:location])
      end

      private def conversion_event_time_to_datetime
        now_monotonic = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        elapsed = now_monotonic - @event.time
        now = Time.now.to_f

        Time.at((now - elapsed).to_i)
      end

      private def round_value(value)
        value&.round(2) || 0
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
