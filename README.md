# AnyLogger

A DSL for simplifying modification of Rails ActiveSupport Instrumentation API

### Example

```ruby
# initializers/any_logger.rb
require "any_logger"
require "any_logger/example/controller_subscriber"

AnyLogger.configure do |config|
  config.logger = Rails::Rack::Logger # default: AnyLogger::Example::RackLogger

  config.subscriber.attach :action_mailer, MyLogger::ModelSubscriber
  # If you call swap, detach, or attach directly in config, the subscriber will be set
  config.swap :action_controller, AnyLogger::Example::ControllerSubscriber
  config.detach :action_view

  # Event can be attached using either a class or a block
  config.event.swap :active_record, :sql, MyLogger::ActiveRecord::Sql
  config.event.attach :active_job, :discard do |event|
    MyErrorReporter.notify(event)
  end
end
```
