import 'dart:async';

import 'package:emptyable_timer/emptyable_timer.dart';

void main() {
  // A solution with a regular timer
  //
  // despite the fact that the method [dispose] was called
  // and the method _someHeavyDelayedRequest() would work
  final someClassWithRegularTimer = SomeClassWithRegularTimer();
  someClassWithRegularTimer.dispose();

  // A solution with EmptyableTimer
  //
  // Uncomment the code below to test
  // final someClassWithEmptyableTimer = SomeClassWithEmptyableTimer();
  // someClassWithEmptyableTimer.dispose();
}

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
