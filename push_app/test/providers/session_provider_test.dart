import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_app/models/workout.dart';
import 'package:push_app/providers/session_provider.dart';

void main() {
  group('SessionNotifier', () {
    late ProviderContainer container;
    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('starts in idle status', () {
      expect(container.read(sessionProvider).status, SessionStatus.idle);
    });

    test('startWorkout sets active status', () {
      container.read(sessionProvider.notifier).startWorkout(Workout.foundationsPush);
      expect(container.read(sessionProvider).status, SessionStatus.active);
      expect(container.read(sessionProvider).moveIndex, 0);
    });

    test('logSet on non-last set moves to resting', () {
      container.read(sessionProvider.notifier).startWorkout(Workout.foundationsPush);
      container.read(sessionProvider.notifier).logSet(12);
      expect(container.read(sessionProvider).status, SessionStatus.resting);
      expect(container.read(sessionProvider).setIndex, 1);
    });

    test('discard resets to idle', () {
      container.read(sessionProvider.notifier).startWorkout(Workout.foundationsPush);
      container.read(sessionProvider.notifier).discard();
      expect(container.read(sessionProvider).status, SessionStatus.idle);
      expect(container.read(sessionProvider).workout, isNull);
    });

    test('addRestTime adds to remaining seconds', () {
      container.read(sessionProvider.notifier).startWorkout(Workout.foundationsPush);
      container.read(sessionProvider.notifier).logSet(12);
      final before = container.read(sessionProvider).restRemainingSeconds;
      container.read(sessionProvider.notifier).addRestTime(15);
      expect(container.read(sessionProvider).restRemainingSeconds, before + 15);
    });
  });
}
