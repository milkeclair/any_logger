# frozen_string_literal: true

require "any_logger"
require "any_logger/example/controller_subscriber"
require_relative "support/mock_application"
require_relative "support/helper"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Support::Helper
end
