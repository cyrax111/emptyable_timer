import 'dart:async';

/// A convenient timer which can be empty (instead of nullable).
/// It can be canceled and can be checked for cancellation by using [isCancel] property.
/// It implements [Timer] and have the same constructors: default and periodic [EmptyableTimer.periodic]
/// and the same behavior except below.
/// Also there is [EmptyableTimer.empty] constructor which creates an empty timer
/// which [isActive] property is false and [isCancel] is false as well.
/// Then one needs it can be canceled by calling [cancel] as a result
/// the property [isCanceled] will be true.
///
/// Example:
/// ```dart
/// class SomeClassWithEmptyableTimer {
///   SomeClassWithEmptyableTimer() {
///     _init();
///   }
///   EmptyableTimer _timer = EmptyableTimer.empty();
///
///   Future<void> _init() async {
///     await _someDelayedRequest();
///     if (_timer.isCanceled) {
///       return;
///     }
///     _timer = EmptyableTimer(const Duration(seconds: 2), _someHeavyDelayedRequest);
///   }
///
///   Future<void> _someDelayedRequest() => Future.delayed(Duration.zero);
///   Future<void> _someHeavyDelayedRequest() async {
///     await Future.delayed(const Duration(seconds: 30));
///     print('_someHeavyDelayedRequest finished');
///   }
///
///   void dispose() {
///     _timer.cancel();
///   }
/// }
/// ```
/// The example shows us we can call [dispose] immediately after creation of [SomeClassWithEmptyableTimer]
/// and a new timer will not be started hence _someHeavyDelayedRequest() will not be called.
class EmptyableTimer implements Timer {
  EmptyableTimer.empty() : _timer = null;
  EmptyableTimer(Duration duration, VoidCallback callback)
      : _timer = Timer(duration, callback);
  EmptyableTimer.periodic(Duration duration, TimerCallback callback)
      : _timer = Timer.periodic(duration, callback);

  final Timer? _timer;

  bool _isCanceled = false;

  /// Checks if the timer was canceled or not.
  bool get isCanceled => _isCanceled;

  /// Cancels the timer. An empty timer can be canceled as well.
  ///
  /// Once a [Timer] has been canceled, the callback function will not be called
  /// by the timer. Calling [cancel] more than once on a [Timer] is allowed, and
  /// will have no further effect.
  @override
  void cancel() {
    _isCanceled = true;
    final timer = _timer;
    if (timer == null) {
      return;
    }
    timer.cancel();
  }

  /// Returns whether the timer is still active.
  /// An empty timer is always inactive (isActive is false).
  ///
  /// A non-periodic timer is active if the callback has not been executed,
  /// and the timer has not been canceled.
  ///
  /// A periodic timer is active if it has not been canceled.
  @override
  bool get isActive {
    final timer = _timer;
    if (timer == null) {
      return false;
    }
    return timer.isActive;
  }

  /// The number of durations preceding the most recent timer event.
  /// The tick of the empty timer is always zero.
  @override
  int get tick {
    final timer = _timer;
    if (timer == null) {
      return 0;
    }
    return timer.tick;
  }
}

typedef VoidCallback = void Function();
typedef TimerCallback = void Function(Timer timer);
