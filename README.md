# AnyLogger

A DSL for simplifying modification of Rails LogSubscribers

### Example

```ruby
require "any_logger"
require "any_logger/example/controller_subscriber"

AnyLogger.configure do |config|
  config.logger = Rails::Rack::Logger # default: AnyLogger::Example::RackLogger
  config.swap :action_controller, AnyLogger::Example::ControllerSubscriber
  config.detach :action_view
  config.attach :active_record, MyLogger::ModelSubscriber
end

AnyLogger.start
```
