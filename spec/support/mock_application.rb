require "rails"
require "action_controller/railtie"

module Support
  class MockApplication < Rails::Application
    config.eager_load = false
    config.secret_key_base = "test"

    def initialize
      super
      config.middleware.use Rails::Rack::Logger
    end
  end
end
