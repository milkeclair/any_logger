## [Unreleased]

## [0.1.0] - 2025-01-14

- Initial release

## [0.1.2] - 2025-01-14

- detach, attach, swapが正常に動作していなかったのを修正

## [0.1.3] - 2025-01-15

- AnyLogger.startをデフォルトで不要に変更

## [0.1.4] - 2025-01-15

- Example::ControllerSubscriberのログの改行位置がおかしかったのを修正

## [0.1.5] - 2025-01-15

- except_unnecessary_paramsをexpectに誤字していたのを修正

## [0.2.0] - 2025-01-19

- process_action.action_controllerのような個別のイベントに対応

## [0.2.1] - 2025-01-20

- Example::ControllerSubscriberのparamsに関するログが、paramsが空の場合にも出力される問題を修正
- config.subscriber.detach :action_viewをしたときに、
  ActionView::LogSubscriberがデフォルトでsubscribeするイベントをunsubscribeするように変更
