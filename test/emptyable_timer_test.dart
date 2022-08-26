import 'package:emptyable_timer/emptyable_timer.dart';
import 'package:test/test.dart';

void main() {
  test('EmptyableTimer cancel test', () {
    final timer = EmptyableTimer.empty();
    expect(timer.isActive, isFalse);
    expect(timer.isCanceled, isFalse);
    expect(timer.tick, equals(0));

    timer.cancel();
    expect(timer.isActive, isFalse);
    expect(timer.isCanceled, isTrue);
    expect(timer.tick, equals(0));
  });
}
