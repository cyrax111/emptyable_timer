A handy timer that can be empty rather than nullable. Emptyable timer can be checked to see if it is canceled. Otherwise, it is a regular timer.

## Features

* can be defined as `EmptyableTimer timer = EmptyableTimer.empty` instead of `Timer? timer`;
* can be checked to see if it is `isCancel` or not (in some cases it can be inactive but not canceled).

## Motivation
Consider the follow example:
```dart
class SomeClassWithRegularTimer {
  SomeClassWithRegularTimer() {
    _init();
  }
  Timer? _timer;

  Future<void> _init() async {
    await _someDelayedRequest();
    _timer = Timer(const Duration(seconds: 2), _someHeavyDelayedRequest);
  }

  Future<void> _someDelayedRequest() => Future.delayed(Duration.zero);
  Future<void> _someHeavyDelayedRequest() async {
    await Future.delayed(const Duration(seconds: 30));
    print('_someHeavyDelayedRequest finished');
  }

  void dispose() {
    _timer?.cancel();
  }
}
```

in this case despite the fact that the method [dispose] was called the method _someHeavyDelayedRequest() would work
```dart
void main() {
  final someClassWithRegularTimer = SomeClassWithRegularTimer();
  someClassWithRegularTimer.dispose();
}
```

## Solution
As one of solution we can use `EmptyableTimer` and its `empty` constructor. Consider the follow example:
```dart
class SomeClassWithEmptyableTimer {
  SomeClassWithEmptyableTimer() {
    _init();
  }
  // The timer is not nullable
  EmptyableTimer _timer = EmptyableTimer.empty();

  Future<void> _init() async {
    await _someDelayedRequest();
    // can check if is canceled ot not
    if (_timer.isCanceled) {
      return;
    }
    _timer =
        EmptyableTimer(const Duration(seconds: 2), _someHeavyDelayedRequest);
  }

  Future<void> _someDelayedRequest() => Future.delayed(Duration.zero);
  Future<void> _someHeavyDelayedRequest() async {
    await Future.delayed(const Duration(seconds: 30));
    print('_someHeavyDelayedRequest finished');
  }

  void dispose() {
    // can call [cancel] without additional code
    _timer.cancel();
  }
}
```
we can cancel an empty timer and check `isCanceled`
```dart
void main() {
  final someClassWithEmptyableTimer = SomeClassWithEmptyableTimer();
  someClassWithEmptyableTimer.dispose();
}
```
in this case the method _someHeavyDelayedRequest() will never called.