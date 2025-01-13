# AnyLogger

Easier to change LogSubscribers in rails.

### Example

```ruby
AnyLogger.configure do |config|
  config.logger = Rails::Rack::Logger # default: AnyLogger::Example::RackLogger
  config.swap :action_controller, AnyLogger::Example::ControllerSubscriber
  config.detach :action_view
  config.attach :active_record, MyLogger::ModelSubscriber
end

AnyLogger.start
```
