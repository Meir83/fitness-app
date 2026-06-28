import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';

enum SessionStatus { idle, active, resting, complete, earlyExit }

class SessionState {
  const SessionState({
    this.workout,
    this.moveIndex = 0,
    this.setIndex = 0,
    this.completedSets = const [],
    this.elapsedSeconds = 0,
    this.restRemainingSeconds = 60,
    this.status = SessionStatus.idle,
  });

  final Workout? workout;
  final int moveIndex;
  final int setIndex;
  final List<int> completedSets; // reps logged per completed set
  final int elapsedSeconds;
  final int restRemainingSeconds;
  final SessionStatus status;

  bool get isLastMove => workout != null && moveIndex >= workout!.exercises.length - 1;
  bool get isLastSet  => workout != null && setIndex >= (workout!.exercises[moveIndex].sets - 1);

  SessionState copyWith({
    Workout? workout, int? moveIndex, int? setIndex,
    List<int>? completedSets, int? elapsedSeconds,
    int? restRemainingSeconds, SessionStatus? status,
  }) => SessionState(
    workout: workout ?? this.workout,
    moveIndex: moveIndex ?? this.moveIndex,
    setIndex: setIndex ?? this.setIndex,
    completedSets: completedSets ?? this.completedSets,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    restRemainingSeconds: restRemainingSeconds ?? this.restRemainingSeconds,
    status: status ?? this.status,
  );
}

final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier();
});

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(const SessionState());

  Timer? _elapsedTimer;
  Timer? _restTimer;

  void startWorkout(Workout workout) {
    state = SessionState(workout: workout, status: SessionStatus.active);
    _startElapsed();
  }

  void logSet(int reps) {
    final newSets = [...state.completedSets, reps];
    if (state.isLastSet && state.isLastMove) {
      _elapsedTimer?.cancel();
      state = state.copyWith(completedSets: newSets, status: SessionStatus.complete);
    } else if (state.isLastSet) {
      state = state.copyWith(
        completedSets: newSets,
        setIndex: 0,
        moveIndex: state.moveIndex + 1,
        restRemainingSeconds: 60,
        status: SessionStatus.resting,
      );
      _startRest();
    } else {
      state = state.copyWith(
        completedSets: newSets,
        setIndex: state.setIndex + 1,
        restRemainingSeconds: 60,
        status: SessionStatus.resting,
      );
      _startRest();
    }
  }

  void addRestTime(int seconds) =>
      state = state.copyWith(restRemainingSeconds: state.restRemainingSeconds + seconds);

  void skipRest() {
    _restTimer?.cancel();
    state = state.copyWith(status: SessionStatus.active);
  }

  void requestEarlyExit() =>
      state = state.copyWith(status: SessionStatus.earlyExit);

  void savePartial() {
    _elapsedTimer?.cancel();
    _restTimer?.cancel();
    state = const SessionState(); // caller reads xp from completed sets before this
  }

  void discard() {
    _elapsedTimer?.cancel();
    _restTimer?.cancel();
    state = const SessionState();
  }

  void _startElapsed() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  void _startRest() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.restRemainingSeconds <= 1) {
        _restTimer?.cancel();
        state = state.copyWith(restRemainingSeconds: 0, status: SessionStatus.active);
      } else {
        state = state.copyWith(restRemainingSeconds: state.restRemainingSeconds - 1);
      }
    });
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }
}
