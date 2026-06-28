# PUSH Calisthenics App — Flutter Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build PUSH, a dark-themed gamified calisthenics training app for Android, across 8 screens matching the design handoff in `Workout app design/design_handoff_push_calisthenics/README.md`.

**Architecture:** Flutter app with Riverpod state management and go_router navigation. A ShellRoute wraps the bottom-nav screens (Home / Library / Progress); the workout sub-flow (Active → Rest → Complete) runs outside the shell as focused routes. Light and dark ThemeData are defined from design tokens; the user toggles via Profile → Settings.

**Tech Stack:** Flutter 3.x · flutter_riverpod ^2.5 · go_router ^14.0 · google_fonts ^6.2 · flutter_animate ^4.5 · shared_preferences ^2.3

---

## Task 1: Flutter Project + Git Initialization

**Files:**
- Create: `push_app/` (Flutter project root)
- Modify: `push_app/pubspec.yaml`

**Step 1: Create Flutter project**
```bash
cd "c:/Users/asda/.cursor/trainig app"
flutter create --org com.push --platforms android push_app
cd push_app
```

**Step 2: Replace pubspec.yaml dependencies section**

In `push_app/pubspec.yaml`, under `dependencies:` replace everything after `flutter: sdk: flutter` with:
```yaml
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.0
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  shared_preferences: ^2.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.9
```

**Step 3: Install dependencies**
```bash
flutter pub get
```
Expected: resolves without errors.

**Step 4: Delete boilerplate**
Delete `push_app/lib/main.dart` content — we'll replace it in Task 5.

**Step 5: Initialize git**
```bash
git init
git add pubspec.yaml pubspec.lock
git commit -m "chore: init flutter project with riverpod + go_router"
```

---

## Task 2: Design Token Files

**Files:**
- Create: `lib/theme/colors.dart`
- Create: `lib/theme/typography.dart`

**Step 1: Create `lib/theme/colors.dart`**
```dart
import 'package:flutter/material.dart';

// Dark palette
const Color bgColor        = Color(0xFF0E100D);
const Color surfaceColor   = Color(0xFF181B16);
const Color trackColor     = Color(0xFF23271F);
const Color trackMuted     = Color(0xFF3A4326);
const Color borderColor    = Color(0x0FFFFFFF); // 6% white

const Color accentColor    = Color(0xFFC9F24A);
const Color onAccent       = Color(0xFF10140A);
const Color onAccentDim    = Color(0xFF46580F);

const Color textColor      = Color(0xFFF3F5EF);
const Color text2Color     = Color(0xFFC7CCC0);
const Color textMuted      = Color(0xFF7E837A);
const Color textDisabled   = Color(0xFF5A5F54);

// Light palette
const Color bgColorLight      = Color(0xFFF4F5F0);
const Color surfaceColorLight = Color(0xFFEBECE6);
const Color trackColorLight   = Color(0xFFD8DAD2);
const Color textColorLight    = Color(0xFF12150F);
const Color text2ColorLight   = Color(0xFF3D4238);
const Color textMutedLight    = Color(0xFF6B7065);
const Color textDisabledLight = Color(0xFF9BA094);

// Shared
const LinearGradient accentGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFC9F24A), Color(0xFFA8D633)],
);
```

**Step 2: Create `lib/theme/typography.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

TextStyle spaceGrotesk({
  required double size,
  required FontWeight weight,
  Color color = textColor,
  double? letterSpacing,
  double? height,
}) =>
    GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );

TextStyle hankenGrotesk({
  required double size,
  required FontWeight weight,
  Color color = textColor,
  double? letterSpacing,
  double? height,
}) =>
    GoogleFonts.hankenGrotesk(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );

// Named styles — design token ramp
final screenTitle  = spaceGrotesk(size: 26, weight: FontWeight.w700);
final greeting     = spaceGrotesk(size: 25, weight: FontWeight.w700, height: 1.08);
final heroNumber   = spaceGrotesk(size: 62, weight: FontWeight.w700, color: accentColor, height: 0.9);
final bigNumber    = spaceGrotesk(size: 48, weight: FontWeight.w700);
final timerStyle   = spaceGrotesk(size: 50, weight: FontWeight.w700);
final statValue    = spaceGrotesk(size: 20, weight: FontWeight.w700);
final buttonLabel  = spaceGrotesk(size: 15, weight: FontWeight.w700, color: onAccent);

final bodyStyle    = hankenGrotesk(size: 13, weight: FontWeight.w500, color: text2Color);
final metaStyle    = hankenGrotesk(size: 11, weight: FontWeight.w600, color: textMuted);
final overlineStyle = hankenGrotesk(
  size: 10, weight: FontWeight.w800, color: textMuted,
  letterSpacing: 0.12 * 10,
);
final navLabel     = hankenGrotesk(size: 9, weight: FontWeight.w600, color: textDisabled);
```

**Step 3: Write unit test `test/theme/colors_test.dart`**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:push_app/theme/colors.dart';

void main() {
  test('accent color matches design spec', () {
    expect(accentColor.value, 0xFFC9F24A);
  });
  test('bg color matches design spec', () {
    expect(bgColor.value, 0xFF0E100D);
  });
}
```

**Step 4: Run test**
```bash
flutter test test/theme/colors_test.dart
```
Expected: 2 tests pass.

**Step 5: Commit**
```bash
git add lib/theme/ test/theme/
git commit -m "feat: add design token colors and typography"
```

---

## Task 3: ThemeData (Light + Dark)

**Files:**
- Create: `lib/theme/theme.dart`

**Step 1: Create `lib/theme/theme.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData buildDarkTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: bgColor,
  colorScheme: const ColorScheme.dark(
    background: bgColor,
    surface: surfaceColor,
    primary: accentColor,
    onPrimary: onAccent,
    onSurface: textColor,
  ),
  textTheme: GoogleFonts.hankenGroteskTextTheme(
    ThemeData.dark().textTheme,
  ).apply(bodyColor: textColor, displayColor: textColor),
  dividerColor: borderColor,
  extensions: const [PushColors.dark()],
);

ThemeData buildLightTheme() => ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: bgColorLight,
  colorScheme: const ColorScheme.light(
    background: bgColorLight,
    surface: surfaceColorLight,
    primary: accentColor,
    onPrimary: onAccent,
    onSurface: textColorLight,
  ),
  textTheme: GoogleFonts.hankenGroteskTextTheme(
    ThemeData.light().textTheme,
  ).apply(bodyColor: textColorLight, displayColor: textColorLight),
  dividerColor: const Color(0x1A000000),
  extensions: const [PushColors.light()],
);

// ThemeExtension so widgets can access semantic colors without knowing dark/light
@immutable
class PushColors extends ThemeExtension<PushColors> {
  const PushColors({
    required this.bg,
    required this.surface,
    required this.track,
    required this.text,
    required this.text2,
    required this.muted,
    required this.disabled,
  });

  const PushColors.dark()
      : bg = bgColor,
        surface = surfaceColor,
        track = trackColor,
        text = textColor,
        text2 = text2Color,
        muted = textMuted,
        disabled = textDisabled;

  const PushColors.light()
      : bg = bgColorLight,
        surface = surfaceColorLight,
        track = trackColorLight,
        text = textColorLight,
        text2 = text2ColorLight,
        muted = textMutedLight,
        disabled = textDisabledLight;

  final Color bg;
  final Color surface;
  final Color track;
  final Color text;
  final Color text2;
  final Color muted;
  final Color disabled;

  @override
  PushColors copyWith({Color? bg, Color? surface, Color? track,
      Color? text, Color? text2, Color? muted, Color? disabled}) =>
      PushColors(
        bg: bg ?? this.bg,
        surface: surface ?? this.surface,
        track: track ?? this.track,
        text: text ?? this.text,
        text2: text2 ?? this.text2,
        muted: muted ?? this.muted,
        disabled: disabled ?? this.disabled,
      );

  @override
  PushColors lerp(PushColors? other, double t) {
    if (other == null) return this;
    return PushColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      track: Color.lerp(track, other.track, t)!,
      text: Color.lerp(text, other.text, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
    );
  }
}

// Convenience extension on BuildContext
extension PushTheme on BuildContext {
  PushColors get pushColors =>
      Theme.of(this).extension<PushColors>()!;
}
```

**Step 2: Commit**
```bash
git add lib/theme/theme.dart
git commit -m "feat: wire light/dark ThemeData with PushColors extension"
```

---

## Task 4: Data Models

**Files:**
- Create: `lib/models/user.dart`
- Create: `lib/models/exercise.dart`
- Create: `lib/models/workout.dart`
- Create: `lib/models/progress.dart`
- Create: `test/models/user_test.dart`

**Step 1: Create `lib/models/user.dart`**
```dart
enum Badge { sevenDay, hundredReps, earlyBird, pullUp, thirtyDay }

enum UserLevel { rookie, mover, athlete, beast }

class UserModel {
  const UserModel({
    required this.name,
    required this.level,
    required this.xp,
    required this.xpToNext,
    required this.streak,
    required this.bestStreak,
    required this.totalWorkouts,
    required this.earnedBadges,
    required this.joinDate,
    required this.selectedGoal,
  });

  final String name;
  final UserLevel level;
  final int xp;
  final int xpToNext;
  final int streak;
  final int bestStreak;
  final int totalWorkouts;
  final List<Badge> earnedBadges;
  final DateTime joinDate;
  final String selectedGoal;

  int get levelNumber => level.index + 1;

  UserModel copyWith({
    String? name, UserLevel? level, int? xp, int? xpToNext,
    int? streak, int? bestStreak, int? totalWorkouts,
    List<Badge>? earnedBadges, DateTime? joinDate, String? selectedGoal,
  }) => UserModel(
    name: name ?? this.name,
    level: level ?? this.level,
    xp: xp ?? this.xp,
    xpToNext: xpToNext ?? this.xpToNext,
    streak: streak ?? this.streak,
    bestStreak: bestStreak ?? this.bestStreak,
    totalWorkouts: totalWorkouts ?? this.totalWorkouts,
    earnedBadges: earnedBadges ?? this.earnedBadges,
    joinDate: joinDate ?? this.joinDate,
    selectedGoal: selectedGoal ?? this.selectedGoal,
  );

  static UserModel get seed => UserModel(
    name: 'Leo Martins',
    level: UserLevel.rookie,
    xp: 320,
    xpToNext: 500,
    streak: 12,
    bestStreak: 18,
    totalWorkouts: 38,
    earnedBadges: [Badge.sevenDay, Badge.hundredReps, Badge.earlyBird],
    joinDate: DateTime(2026, 3, 1),
    selectedGoal: 'Build real strength',
  );
}
```

**Step 2: Create `lib/models/exercise.dart`**
```dart
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
  });

  final String id;
  final String name;
  final String muscleGroup;
  final int sets;
  final int reps;
}
```

**Step 3: Create `lib/models/workout.dart`**
```dart
import 'exercise.dart';

enum Difficulty { beginner, intermediate, advanced }

class Workout {
  const Workout({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.difficulty,
    required this.exercises,
    required this.xpReward,
    required this.category,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final Difficulty difficulty;
  final List<Exercise> exercises;
  final int xpReward;
  final String category;

  static Workout get foundationsPush => Workout(
    id: 'foundations_push',
    title: 'Foundations Push',
    durationMinutes: 28,
    difficulty: Difficulty.beginner,
    xpReward: 120,
    category: 'Push',
    exercises: const [
      Exercise(id: 'pushup',       name: 'Push-ups',       muscleGroup: 'chest & triceps', sets: 3, reps: 12),
      Exercise(id: 'incline_rows', name: 'Incline rows',   muscleGroup: 'back & biceps',   sets: 3, reps: 10),
      Exercise(id: 'pike_push',    name: 'Pike push-ups',  muscleGroup: 'shoulders',       sets: 3, reps: 8),
      Exercise(id: 'dips',         name: 'Dips',           muscleGroup: 'triceps & chest', sets: 3, reps: 10),
      Exercise(id: 'plank',        name: 'Plank hold',     muscleGroup: 'core',            sets: 3, reps: 30),
      Exercise(id: 'neg_pullup',   name: 'Negative pull-ups', muscleGroup: 'back',         sets: 3, reps: 5),
    ],
  );
}
```

**Step 4: Create `lib/models/progress.dart`**
```dart
class PersonalBest {
  const PersonalBest({required this.exercise, required this.value, required this.unit, required this.percentage});
  final String exercise;
  final String value;
  final String unit;
  final double percentage; // 0.0–1.0 for progress bar fill
}

class ProgressModel {
  const ProgressModel({
    required this.weeklyReps,
    required this.totalReps,
    required this.trainedHours,
    required this.personalBests,
  });

  final List<double> weeklyReps; // 7 values, 0.0–1.0 relative heights; index 0 = Mon
  final int totalReps;
  final double trainedHours;
  final List<PersonalBest> personalBests;

  static ProgressModel get seed => const ProgressModel(
    weeklyReps: [0.42, 0.65, 0.50, 0.30, 0.88, 0.55, 0.20],
    totalReps: 4820,
    trainedHours: 10,
    personalBests: [
      PersonalBest(exercise: 'Push-ups',  value: '24',  unit: 'reps', percentage: 0.75),
      PersonalBest(exercise: 'Pull-ups',  value: '5',   unit: 'reps', percentage: 0.30),
      PersonalBest(exercise: 'Plank',     value: '90s', unit: '',     percentage: 0.60),
    ],
  );
}
```

**Step 5: Write `test/models/user_test.dart`**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:push_app/models/user.dart';

void main() {
  group('UserModel', () {
    test('seed returns correct name and streak', () {
      final u = UserModel.seed;
      expect(u.name, 'Leo Martins');
      expect(u.streak, 12);
      expect(u.bestStreak, 18);
    });

    test('levelNumber is 1-based', () {
      expect(UserModel.seed.levelNumber, 1); // rookie = index 0 → level 1
    });

    test('copyWith preserves unmodified fields', () {
      final original = UserModel.seed;
      final updated = original.copyWith(streak: 13);
      expect(updated.streak, 13);
      expect(updated.name, original.name);
    });
  });
}
```

**Step 6: Run tests**
```bash
flutter test test/models/
```
Expected: 3 tests pass.

**Step 7: Commit**
```bash
git add lib/models/ test/models/
git commit -m "feat: add User, Exercise, Workout, Progress models with seed data"
```

---

## Task 5: Riverpod Providers

**Files:**
- Create: `lib/providers/theme_provider.dart`
- Create: `lib/providers/user_provider.dart`
- Create: `lib/providers/session_provider.dart`
- Create: `lib/providers/library_provider.dart`
- Create: `lib/providers/progress_provider.dart`
- Create: `test/providers/session_provider_test.dart`

**Step 1: Create `lib/providers/theme_provider.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) {
    _load();
  }

  static const _key = 'theme_mode';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == 'light') state = ThemeMode.light;
    if (saved == 'dark')  state = ThemeMode.dark;
  }

  Future<void> toggle() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, state == ThemeMode.dark ? 'dark' : 'light');
  }
}
```

**Step 2: Create `lib/providers/user_provider.dart`**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel.seed);

  void selectGoal(String goal) => state = state.copyWith(selectedGoal: goal);

  void completeOnboarding() {
    // Called after Continue on onboarding
  }

  void addXp(int amount) {
    int newXp = state.xp + amount;
    UserLevel newLevel = state.level;
    int newXpToNext = state.xpToNext;
    if (newXp >= state.xpToNext) {
      newXp -= state.xpToNext;
      newLevel = UserLevel.values[
          (state.level.index + 1).clamp(0, UserLevel.values.length - 1)];
      newXpToNext = (state.xpToNext * 1.5).round();
    }
    state = state.copyWith(xp: newXp, level: newLevel, xpToNext: newXpToNext);
  }

  void incrementStreak() {
    final newStreak = state.streak + 1;
    state = state.copyWith(
      streak: newStreak,
      bestStreak: newStreak > state.bestStreak ? newStreak : state.bestStreak,
    );
  }

  void incrementWorkouts() =>
      state = state.copyWith(totalWorkouts: state.totalWorkouts + 1);
}
```

**Step 3: Create `lib/providers/session_provider.dart`**
```dart
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
```

**Step 4: Create `lib/providers/library_provider.dart`**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';

const _allWorkouts = [Workout.foundationsPush];

final libraryFilterProvider = StateProvider<String>((ref) => 'Skills');

final workoutsProvider = Provider<List<Workout>>((ref) => _allWorkouts);
```

**Step 5: Create `lib/providers/progress_provider.dart`**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/progress.dart';

final progressProvider = Provider<ProgressModel>((ref) => ProgressModel.seed);
```

**Step 6: Write `test/providers/session_provider_test.dart`**
```dart
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
```

**Step 7: Run tests**
```bash
flutter test test/providers/
```
Expected: 5 tests pass.

**Step 8: Commit**
```bash
git add lib/providers/ test/providers/
git commit -m "feat: add Riverpod providers for theme, user, session, library, progress"
```

---

## Task 6: Router

**Files:**
- Create: `lib/router/router.dart`
- Create: `lib/main.dart`
- Create: `lib/app.dart`

**Step 1: Create `lib/router/router.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/workout/active_workout_screen.dart';
import '../screens/workout/rest_screen.dart';
import '../screens/workout/complete_screen.dart';
import '../widgets/push_bottom_nav.dart';

final router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: const PushBottomNav(),
      ),
      routes: [
        GoRoute(path: '/home',     builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/library',  builder: (_, __) => const LibraryScreen()),
        GoRoute(path: '/progress', builder: (_, __) => const ProgressScreen()),
      ],
    ),
    GoRoute(path: '/profile',          builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/workout/active',   builder: (_, __) => const ActiveWorkoutScreen()),
    GoRoute(path: '/workout/rest',     builder: (_, __) => const RestScreen()),
    GoRoute(path: '/workout/complete', builder: (_, __) => const CompleteScreen()),
  ],
);
```

**Step 2: Create `lib/app.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/theme_provider.dart';
import 'router/router.dart';
import 'theme/theme.dart';

class PushApp extends ConsumerWidget {
  const PushApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      title: 'PUSH',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

**Step 3: Create `lib/main.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  runApp(const ProviderScope(child: PushApp()));
}
```

**Step 4: Create stub screens so the app compiles** — create a `_Stub` widget file at `lib/screens/_stubs.dart`:
```dart
import 'package:flutter/material.dart';
// Temporary stubs — replaced task by task
class OnboardingScreen  extends StatelessWidget { const OnboardingScreen({super.key});  @override Widget build(BuildContext c) => const Scaffold(body: Center(child: Text('Onboarding'))); }
class HomeScreen        extends StatelessWidget { const HomeScreen({super.key});        @override Widget build(BuildContext c) => const Scaffold(body: Center(child: Text('Home'))); }
class LibraryScreen     extends StatelessWidget { const LibraryScreen({super.key});     @override Widget build(BuildContext c) => const Scaffold(body: Center(child: Text('Library'))); }
class ProgressScreen    extends StatelessWidget { const ProgressScreen({super.key});    @override Widget build(BuildContext c) => const Scaffold(body: Center(child: Text('Progress'))); }
class ProfileScreen     extends StatelessWidget { const ProfileScreen({super.key});     @override Widget build(BuildContext c) => const Scaffold(body: Center(child: Text('Profile'))); }
class ActiveWorkoutScreen extends StatelessWidget { const ActiveWorkoutScreen({super.key}); @override Widget build(BuildContext c) => const Scaffold(body: Center(child: Text('Active'))); }
class RestScreen        extends StatelessWidget { const RestScreen({super.key});        @override Widget build(BuildContext c) => const Scaffold(body: Center(child: Text('Rest'))); }
class CompleteScreen    extends StatelessWidget { const CompleteScreen({super.key});    @override Widget build(BuildContext c) => const Scaffold(body: Center(child: Text('Complete'))); }
```

Also create `lib/widgets/push_bottom_nav.dart` stub:
```dart
import 'package:flutter/material.dart';
class PushBottomNav extends StatelessWidget {
  const PushBottomNav({super.key});
  @override Widget build(BuildContext context) => const SizedBox.shrink();
}
```

Update router.dart imports to point to `_stubs.dart` temporarily.

**Step 5: Verify app compiles**
```bash
flutter build apk --debug 2>&1 | tail -5
```
Expected: `Built build/app/outputs/flutter-apk/app-debug.apk`

**Step 6: Commit**
```bash
git add lib/
git commit -m "feat: wire go_router with ShellRoute + stub screens"
```

---

## Task 7: Shared Widgets

**Files:**
- Create: `lib/widgets/push_bottom_nav.dart` (replace stub)
- Create: `lib/widgets/push_button.dart`
- Create: `lib/widgets/striped_placeholder.dart`
- Create: `lib/widgets/push_progress_bar.dart`
- Create: `lib/widgets/streak_dot.dart`
- Create: `lib/widgets/early_exit_sheet.dart`

**Step 1: `lib/widgets/push_bottom_nav.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../theme/typography.dart' as t;

class PushBottomNav extends StatelessWidget {
  const PushBottomNav({super.key});

  static const _tabs = [
    (label: 'Home',     icon: Icons.grid_view_rounded,    path: '/home'),
    (label: 'Train',    icon: Icons.circle_outlined,      path: '/home'), // placeholder
    (label: 'Library',  icon: Icons.crop_square_rounded,  path: '/library'),
    (label: 'Progress', icon: Icons.bar_chart_rounded,    path: '/progress'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x12FFFFFF), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 9, 14, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _tabs.map((tab) {
              final active = location == tab.path;
              final color = active ? accentColor : textDisabled;
              return GestureDetector(
                onTap: () => context.go(tab.path),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tab.icon, color: color, size: 22),
                    const SizedBox(height: 3),
                    Text(tab.label, style: t.navLabel.copyWith(color: color)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
```

**Step 2: `lib/widgets/push_button.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/colors.dart';
import '../theme/typography.dart' as t;

class PushPrimaryButton extends StatelessWidget {
  const PushPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.showArrow = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: t.buttonLabel),
            if (showArrow) ...[
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward, color: onAccent, size: 16)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveX(begin: 0, end: 3, duration: 1600.ms, curve: Curves.easeInOut),
            ],
          ],
        ),
      ),
    );
  }
}

class PushGhostButton extends StatelessWidget {
  const PushGhostButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x20FFFFFF)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(label,
              style: t.buttonLabel.copyWith(color: textColor)),
        ),
      ),
    );
  }
}
```

**Step 3: `lib/widgets/striped_placeholder.dart`**
```dart
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class StripedPlaceholder extends StatelessWidget {
  const StripedPlaceholder({super.key, required this.height, this.label, this.width});
  final double height;
  final double? width;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(11),
      ),
      child: CustomPaint(
        painter: _StripePainter(),
        child: label != null
            ? Center(
                child: Text(label!,
                    style: const TextStyle(
                        color: Color(0xFF3A4326),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1)),
              )
            : null,
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1C2018)
      ..strokeWidth = 8;
    for (double x = -size.height; x < size.width + size.height; x += 16) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
```

**Step 4: `lib/widgets/push_progress_bar.dart`**
```dart
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PushProgressBar extends StatelessWidget {
  const PushProgressBar({super.key, required this.value, this.height = 3});
  final double value; // 0.0–1.0
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: trackColor,
        valueColor: const AlwaysStoppedAnimation<Color>(accentColor),
      ),
    );
  }
}
```

**Step 5: `lib/widgets/streak_dot.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/colors.dart';

class StreakDot extends StatelessWidget {
  const StreakDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8, height: 8,
      decoration: const BoxDecoration(
        color: accentColor,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .boxShadow(
          begin: const BoxShadow(color: Color(0x80C9F24A), blurRadius: 7),
          end:   const BoxShadow(color: Color(0x80C9F24A), blurRadius: 16),
          duration: 2000.ms,
          curve: Curves.easeInOut,
        );
  }
}
```

**Step 6: `lib/widgets/early_exit_sheet.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/session_provider.dart';
import '../providers/user_provider.dart';
import '../theme/colors.dart';
import '../theme/typography.dart' as t;
import 'push_button.dart';

class EarlyExitSheet extends ConsumerWidget {
  const EarlyExitSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF181B16),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => const EarlyExitSheet(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final setsCount = session.completedSets.length;
    final partialXp = (setsCount * 10).clamp(0, 100);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('End workout early?', style: t.screenTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            'You\'ve completed $setsCount sets so far.',
            style: t.bodyStyle,
          ),
          const SizedBox(height: 24),
          PushPrimaryButton(
            label: 'Save progress (+$partialXp XP)',
            onTap: () {
              ref.read(userProvider.notifier).addXp(partialXp);
              ref.read(sessionProvider.notifier).savePartial();
              context.go('/home');
            },
          ),
          const SizedBox(height: 10),
          PushGhostButton(
            label: 'Discard',
            onTap: () {
              ref.read(sessionProvider.notifier).discard();
              context.go('/home');
            },
          ),
        ],
      ),
    );
  }
}
```

**Step 7: Widget test `test/widgets/push_button_test.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_app/widgets/push_button.dart';

void main() {
  testWidgets('PushPrimaryButton shows label and fires callback', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PushPrimaryButton(label: 'Go', onTap: () => tapped = true),
      ),
    ));
    expect(find.text('Go'), findsOneWidget);
    await tester.tap(find.text('Go'));
    expect(tapped, isTrue);
  });
}
```

**Step 8: Run test**
```bash
flutter test test/widgets/
```
Expected: 1 test passes.

**Step 9: Commit**
```bash
git add lib/widgets/ test/widgets/
git commit -m "feat: add shared widgets — bottom nav, buttons, placeholder, progress bar, streak dot, early exit sheet"
```

---

## Task 8: Onboarding Screen

**Files:**
- Create: `lib/screens/onboarding/onboarding_screen.dart`
- Create: `test/screens/onboarding_screen_test.dart`

**Step 1: Create `lib/screens/onboarding/onboarding_screen.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_button.dart';

const _goals = [
  (label: 'Build real strength',  icon: Icons.crop_square_rounded),
  (label: 'My first pull-up',     icon: Icons.circle_outlined),
  (label: 'Get lean & athletic',  icon: Icons.diamond_outlined),
  (label: 'Build a daily habit',  icon: Icons.crop_square_outlined),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String _selected = 'Build real strength';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: PUSH wordmark + Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PUSH',
                      style: t.spaceGrotesk(
                          size: 18, weight: FontWeight.w700,
                          color: accentColor, letterSpacing: 18 * 0.16)),
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Text('Skip', style: t.metaStyle),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Step indicator
              Row(children: [
                Expanded(flex: 2, child: Container(height: 3, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(3)))),
                const SizedBox(width: 4),
                Expanded(child: Container(height: 3, decoration: BoxDecoration(color: trackColor, borderRadius: BorderRadius.circular(3)))),
                const SizedBox(width: 4),
                Expanded(child: Container(height: 3, decoration: BoxDecoration(color: trackColor, borderRadius: BorderRadius.circular(3)))),
              ]),
              const SizedBox(height: 24),
              Text("What's your goal?", style: t.screenTitle),
              const SizedBox(height: 8),
              Text('We\'ll shape your first plan around it.',
                  style: t.bodyStyle),
              const SizedBox(height: 20),
              // Goal cards
              ...List.generate(_goals.length, (i) {
                final goal = _goals[i];
                final selected = _selected == goal.label;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = goal.label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0x17C9F24A)
                            : surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? accentColor : borderColor,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34, height: 34,
                            decoration: BoxDecoration(
                              color: trackColor,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(goal.icon, color: textMuted, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(goal.label,
                                  style: t.hankenGrotesk(
                                      size: 14,
                                      weight: FontWeight.w600,
                                      color: selected ? textColor : text2Color))),
                          if (selected)
                            Container(
                              width: 20, height: 20,
                              decoration: const BoxDecoration(
                                  color: accentColor, shape: BoxShape.circle),
                              child: const Icon(Icons.check,
                                  color: onAccent, size: 13),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              PushPrimaryButton(
                label: 'Continue',
                showArrow: true,
                onTap: () {
                  ref.read(userProvider.notifier).selectGoal(_selected);
                  context.go('/home');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Write widget test**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_app/screens/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('Onboarding shows goal cards and PUSH wordmark', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: OnboardingScreen()),
    ));
    await tester.pump();
    expect(find.text('PUSH'), findsOneWidget);
    expect(find.text("What's your goal?"), findsOneWidget);
    expect(find.text('Build real strength'), findsOneWidget);
    expect(find.text('My first pull-up'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Tapping goal card selects it', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: OnboardingScreen()),
    ));
    await tester.pump();
    await tester.tap(find.text('My first pull-up'));
    await tester.pump();
    // Just verifying it doesn't throw
    expect(find.text('My first pull-up'), findsOneWidget);
  });
}
```

**Step 3: Run tests**
```bash
flutter test test/screens/onboarding_screen_test.dart
```

**Step 4: Commit**
```bash
git add lib/screens/onboarding/ test/screens/
git commit -m "feat: implement Onboarding screen with goal selection"
```

---

## Task 9: Home Screen

**Files:**
- Create: `lib/screens/home/home_screen.dart`
- Create: `lib/screens/home/widgets/level_ring.dart`
- Create: `lib/screens/home/widgets/streak_chip.dart`
- Create: `lib/screens/home/widgets/hero_card.dart`
- Create: `lib/screens/home/widgets/week_strip.dart`

**Step 1: `lib/screens/home/widgets/level_ring.dart`**
```dart
import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart' as t;

class LevelRing extends StatelessWidget {
  const LevelRing({super.key, required this.level, required this.label, required this.progress});
  final int level;
  final String label;
  final double progress; // 0.0–1.0

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56, height: 56,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('L$level',
                  style: t.spaceGrotesk(size: 16, weight: FontWeight.w700)),
              Text(label,
                  style: t.hankenGrotesk(
                      size: 7, weight: FontWeight.w800,
                      color: textMuted, letterSpacing: 7 * 0.12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const strokeW = 5.0;
    final radius = (size.width - strokeW) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW;
    canvas.drawCircle(Offset(cx, cy), radius, trackPaint);

    final arcPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      -1.5707963, // -90 degrees
      2 * 3.14159 * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
```

**Step 2: `lib/screens/home/widgets/streak_chip.dart`**
```dart
import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart' as t;
import '../../../widgets/streak_dot.dart';

class StreakChip extends StatelessWidget {
  const StreakChip({super.key, required this.streak, required this.best});
  final int streak;
  final int best;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const StreakDot(),
          const SizedBox(width: 8),
          Text('$streak-day streak',
              style: t.hankenGrotesk(size: 13, weight: FontWeight.w600)),
          const Spacer(),
          Text('Best $best',
              style: t.metaStyle.copyWith(color: textMuted)),
        ],
      ),
    );
  }
}
```

**Step 3: `lib/screens/home/widgets/hero_card.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../models/workout.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart' as t;

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.workout, required this.onStart});
  final Workout workout;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TODAY · PUSH DAY',
              style: t.overlineStyle.copyWith(color: onAccentDim)),
          const SizedBox(height: 6),
          Text(workout.title,
              style: t.spaceGrotesk(
                  size: 23, weight: FontWeight.w700, color: onAccent)),
          const SizedBox(height: 4),
          Text(
            '${workout.exercises.length} moves · ${workout.durationMinutes} min · Beginner',
            style: t.hankenGrotesk(
                size: 12, weight: FontWeight.w600, color: onAccentDim),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: onAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Start workout',
                      style: t.buttonLabel.copyWith(color: accentColor)),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, color: accentColor, size: 15)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveX(begin: 0, end: 3, duration: 1600.ms, curve: Curves.easeInOut),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Step 4: `lib/screens/home/widgets/week_strip.dart`**
```dart
import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart' as t;

class WeekStrip extends StatelessWidget {
  const WeekStrip({super.key, required this.completedCount, required this.todayIndex});
  final int completedCount;
  final int todayIndex; // 0=Mon … 6=Sun

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('This week',
                style: t.hankenGrotesk(size: 13, weight: FontWeight.w600)),
            Text('$completedCount of 7',
                style: t.metaStyle),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final done = i < completedCount;
            final isToday = i == todayIndex;
            return Column(
              children: [
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: done ? accentColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    border: isToday && !done
                        ? Border.all(color: accentColor, width: 1.5)
                        : done
                            ? null
                            : Border.all(color: trackColor, width: 1.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(_days[i],
                    style: t.hankenGrotesk(
                        size: 10, weight: FontWeight.w700, color: textMuted)),
              ],
            );
          }),
        ),
      ],
    );
  }
}
```

**Step 5: `lib/screens/home/home_screen.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/workout.dart';
import '../../providers/session_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import 'widgets/hero_card.dart';
import 'widgets/level_ring.dart';
import 'widgets/streak_chip.dart';
import 'widgets/week_strip.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final now = DateTime.now();
    final dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final monthNames = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    final dateLabel = '${dayNames[now.weekday - 1]} ${now.day} ${monthNames[now.month - 1]}';

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateLabel,
                            style: t.overlineStyle),
                        const SizedBox(height: 4),
                        Text("Let's go, ${user.name.split(' ').first}.",
                            style: t.greeting),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: LevelRing(
                      level: user.levelNumber,
                      label: user.level.name.toUpperCase(),
                      progress: user.xp / user.xpToNext,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              StreakChip(streak: user.streak, best: user.bestStreak),
              const SizedBox(height: 14),
              HeroCard(
                workout: Workout.foundationsPush,
                onStart: () {
                  ref.read(sessionProvider.notifier)
                      .startWorkout(Workout.foundationsPush);
                  context.push('/workout/active');
                },
              ),
              const SizedBox(height: 14),
              WeekStrip(completedCount: 4, todayIndex: now.weekday - 1),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Step 6: Run widget test**
```bash
flutter test test/screens/
```

**Step 7: Commit**
```bash
git add lib/screens/home/ test/screens/
git commit -m "feat: implement Home screen with level ring, streak chip, hero card, week strip"
```

---

## Task 10: Library Screen

**Files:**
- Create: `lib/screens/library/library_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/library_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_progress_bar.dart';
import '../../widgets/striped_placeholder.dart';

const _filters = ['Skills', 'Push', 'Pull', 'Core'];

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(libraryFilterProvider);
    final workouts = ref.watch(workoutsProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Library', style: t.screenTitle),
              const SizedBox(height: 13),
              // Search field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(children: [
                  const Icon(Icons.search, color: Color(0xFF7E837A), size: 18),
                  const SizedBox(width: 8),
                  Text('Search moves & workouts',
                      style: t.bodyStyle.copyWith(color: textMuted)),
                ]),
              ),
              const SizedBox(height: 13),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final active = f == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => ref.read(libraryFilterProvider.notifier).state = f,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: active ? accentColor : surfaceColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(f,
                              style: t.hankenGrotesk(
                                  size: 13, weight: FontWeight.w700,
                                  color: active ? onAccent : text2Color)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              // Skill paths
              Text('Skill paths',
                  style: t.hankenGrotesk(size: 14, weight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _SkillPathCard(title: 'First Pull-up', progress: 0.40)),
                  const SizedBox(width: 10),
                  Expanded(child: _SkillPathCard(title: 'Handstand', progress: 0.15)),
                ],
              ),
              const SizedBox(height: 20),
              Text('Workouts',
                  style: t.hankenGrotesk(size: 14, weight: FontWeight.w700)),
              const SizedBox(height: 10),
              ...workouts.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _WorkoutRow(
                  title: w.title,
                  meta: '${w.durationMinutes} min · Beginner',
                  difficulty: 1,
                ),
              )),
              const _WorkoutRow(
                title: 'Core Crusher',
                meta: '22 min · Beginner',
                difficulty: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillPathCard extends StatelessWidget {
  const _SkillPathCard({required this.title, required this.progress});
  final String title;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StripedPlaceholder(height: 64),
          const SizedBox(height: 10),
          Text(title,
              style: t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          PushProgressBar(value: progress),
          const SizedBox(height: 4),
          Text('${(progress * 100).round()}% there',
              style: t.metaStyle),
        ],
      ),
    );
  }
}

class _WorkoutRow extends StatelessWidget {
  const _WorkoutRow({required this.title, required this.meta, required this.difficulty});
  final String title;
  final String meta;
  final int difficulty; // 1–3

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          StripedPlaceholder(height: 46, width: 46),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(meta, style: t.metaStyle),
              ],
            ),
          ),
          Row(
            children: List.generate(3, (i) => Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Container(
                width: 6, height: 6,
                decoration: BoxDecoration(
                  color: i < difficulty ? accentColor : trackColor,
                  shape: BoxShape.circle,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
```

**Commit:**
```bash
git add lib/screens/library/
git commit -m "feat: implement Library screen with filter chips, skill paths, workout list"
```

---

## Task 11: Profile Screen

**Files:**
- Create: `lib/screens/profile/profile_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_progress_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                          color: surfaceColor, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: textColor, size: 18),
                    ),
                  ),
                  const Spacer(),
                  Text('Profile', style: t.hankenGrotesk(size: 15, weight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: surfaceColor, shape: BoxShape.circle),
                    child: const Icon(Icons.settings_outlined, color: textColor, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Identity
              Row(
                children: [
                  Container(
                    width: 62, height: 62,
                    decoration: const BoxDecoration(
                      gradient: accentGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        user.name[0],
                        style: t.spaceGrotesk(size: 26, weight: FontWeight.w700, color: onAccent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: t.spaceGrotesk(size: 19, weight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('Level ${user.levelNumber} · ${_capitalize(user.level.name)}',
                          style: t.hankenGrotesk(size: 13, weight: FontWeight.w600, color: accentColor)),
                      Text('Joined Mar 2026', style: t.metaStyle),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // XP card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Level ${user.levelNumber + 1} · Mover',
                            style: t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
                        Text('${user.xp} / ${user.xpToNext} XP',
                            style: t.metaStyle.copyWith(color: accentColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    PushProgressBar(value: user.xp / user.xpToNext, height: 5),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Stat triplet
              Row(
                children: [
                  _StatTile(label: 'Streak', value: '${user.streak}'),
                  const SizedBox(width: 8),
                  _StatTile(label: 'Workouts', value: '${user.totalWorkouts}'),
                  const SizedBox(width: 8),
                  _StatTile(label: 'Badges', value: '${user.earnedBadges.length}'),
                ],
              ),
              const SizedBox(height: 14),
              // Badges
              Text('Badges',
                  style: t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
              const SizedBox(height: 10),
              _BadgesRow(earned: user.earnedBadges),
              const SizedBox(height: 14),
              // Settings list
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _SettingsRow(label: 'My goal', value: user.selectedGoal),
                    _Divider(),
                    _SettingsRow(label: 'Reminders', value: '9:00 AM'),
                    _Divider(),
                    // Appearance toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Appearance',
                                style: t.hankenGrotesk(size: 13, weight: FontWeight.w600)),
                          ),
                          GestureDetector(
                            onTap: () => ref.read(themeProvider.notifier).toggle(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: trackColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                themeMode == ThemeMode.dark ? '🌙 Dark' : '☀️ Light',
                                style: t.hankenGrotesk(size: 12, weight: FontWeight.w700, color: text2Color),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _Divider(),
                    _SettingsRow(label: 'Account & settings', value: ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(13)),
      child: Column(
        children: [
          Text(value, style: t.statValue),
          const SizedBox(height: 2),
          Text(label, style: t.metaStyle),
        ],
      ),
    ),
  );
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({required this.earned});
  final List<Badge> earned;

  static const _allBadges = [
    (badge: Badge.sevenDay,    label: '7-day'),
    (badge: Badge.hundredReps, label: '100 reps'),
    (badge: Badge.earlyBird,   label: 'Early bird'),
    (badge: Badge.pullUp,      label: 'Pull-up'),
    (badge: Badge.thirtyDay,   label: '30-day'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _allBadges.map((b) {
        final isEarned = earned.contains(b.badge);
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  gradient: isEarned ? accentGradient : null,
                  shape: BoxShape.circle,
                  border: isEarned ? null : Border.all(
                    color: const Color(0xFF3A4034),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(b.label, style: t.metaStyle.copyWith(fontSize: 9)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    child: Row(
      children: [
        Expanded(child: Text(label,
            style: t.hankenGrotesk(size: 13, weight: FontWeight.w600))),
        if (value.isNotEmpty)
          Text(value, style: t.metaStyle),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right, color: Color(0xFF5A5F54), size: 16),
      ],
    ),
  );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    color: borderColor,
    margin: const EdgeInsets.symmetric(horizontal: 14),
  );
}
```

**Commit:**
```bash
git add lib/screens/profile/
git commit -m "feat: implement Profile screen with XP card, badges, settings, theme toggle"
```

---

## Task 12: Active Workout Screen

**Files:**
- Create: `lib/screens/workout/active_workout_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/session_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/early_exit_sheet.dart';
import '../../widgets/push_button.dart';
import '../../widgets/push_progress_bar.dart';
import '../../widgets/striped_placeholder.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key});

  String _fmt(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (session.workout == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/home'));
      return const SizedBox.shrink();
    }

    final workout  = session.workout!;
    final exercise = workout.exercises[session.moveIndex];
    final totalMoves = workout.exercises.length;
    final progress = (session.moveIndex + 1) / totalMoves;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => EarlyExitSheet.show(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                          color: surfaceColor, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: textColor, size: 18),
                    ),
                  ),
                  const Spacer(),
                  Text(workout.title.toUpperCase(),
                      style: t.overlineStyle),
                  const Spacer(),
                  Text(_fmt(session.elapsedSeconds),
                      style: t.hankenGrotesk(
                          size: 13, weight: FontWeight.w700, color: accentColor)),
                ],
              ),
              const SizedBox(height: 14),
              // Progress
              PushProgressBar(value: progress),
              const SizedBox(height: 6),
              Text('Move ${session.moveIndex + 1} of $totalMoves',
                  style: t.metaStyle),
              const SizedBox(height: 14),
              // Demo placeholder
              StripedPlaceholder(
                height: 188,
                label: '${exercise.name.toUpperCase()} · DEMO',
              ),
              const SizedBox(height: 14),
              Text(exercise.name,
                  style: t.spaceGrotesk(size: 27, weight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Set ${session.setIndex + 1} of ${exercise.sets} · ${exercise.muscleGroup}',
                  style: t.bodyStyle),
              const SizedBox(height: 16),
              // Big rep number
              Center(
                child: Column(children: [
                  Text('${exercise.reps}', style: t.heroNumber)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(1, 1), end: const Offset(1.045, 1.045),
                          duration: 2600.ms, curve: Curves.easeInOut),
                  Text('reps', style: t.bodyStyle),
                ]),
              ),
              const SizedBox(height: 16),
              // Set tracker
              Row(
                children: List.generate(exercise.sets, (i) {
                  final done    = i < session.setIndex;
                  final current = i == session.setIndex;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < exercise.sets - 1 ? 6 : 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: current ? accentColor : surfaceColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: done
                              ? Row(mainAxisSize: MainAxisSize.min, children: [
                                  Text('${exercise.reps}',
                                      style: t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
                                  const SizedBox(width: 2),
                                  const Icon(Icons.check, size: 12, color: accentColor),
                                ])
                              : Text(
                                  current ? 'now' : '—',
                                  style: t.hankenGrotesk(
                                      size: 13, weight: FontWeight.w700,
                                      color: current ? onAccent : textMuted),
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),
              // Footer
              Row(children: [
                GestureDetector(
                  onTap: () => context.go('/workout/rest'),
                  child: Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('60s',
                            style: t.hankenGrotesk(size: 11, weight: FontWeight.w700, color: accentColor)),
                        Text('rest', style: t.metaStyle.copyWith(fontSize: 9)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PushPrimaryButton(
                    label: 'Done — log set',
                    onTap: () {
                      ref.read(sessionProvider.notifier).logSet(exercise.reps);
                      final status = ref.read(sessionProvider).status;
                      if (status == SessionStatus.complete) {
                        context.go('/workout/complete');
                      } else {
                        context.go('/workout/rest');
                      }
                    },
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Commit:**
```bash
git add lib/screens/workout/active_workout_screen.dart
git commit -m "feat: implement Active Workout screen with set tracker, rep pulse, early exit"
```

---

## Task 13: Rest Screen

**Files:**
- Create: `lib/screens/workout/rest_screen.dart`

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/session_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/early_exit_sheet.dart';
import '../../widgets/striped_placeholder.dart';

class RestScreen extends ConsumerWidget {
  const RestScreen({super.key});

  String _fmt(int sec) =>
      '${sec ~/ 60}:${(sec % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (session.workout == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/home'));
      return const SizedBox.shrink();
    }

    // Auto-advance when timer hits 0
    if (session.status == SessionStatus.active) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/workout/active');
      });
    }

    final workout = session.workout!;
    final totalRest = 60.0;
    final progress = session.restRemainingSeconds / totalRest;
    final nextExercise = session.moveIndex < workout.exercises.length
        ? workout.exercises[session.moveIndex]
        : null;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => EarlyExitSheet.show(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                          color: surfaceColor, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: textColor, size: 18),
                    ),
                  ),
                  const Spacer(),
                  Text(workout.title.toUpperCase(), style: t.overlineStyle),
                  const Spacer(),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 8),
              Text('REST',
                  style: t.overlineStyle.copyWith(
                      color: accentColor, letterSpacing: 10 * 0.2)),
              const SizedBox(height: 32),
              // Countdown ring
              SizedBox(
                width: 200, height: 200,
                child: CustomPaint(
                  painter: _RestRingPainter(progress: progress.clamp(0.0, 1.0)),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_fmt(session.restRemainingSeconds),
                            style: t.timerStyle),
                        Text('until next set', style: t.metaStyle),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => ref.read(sessionProvider.notifier).addRestTime(15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: Text('+15s',
                            style: t.hankenGrotesk(
                                size: 14, weight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(sessionProvider.notifier).skipRest();
                      context.go('/workout/active');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: Text('Skip',
                            style: t.hankenGrotesk(
                                size: 14, weight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
              ]),
              const Spacer(),
              if (nextExercise != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      StripedPlaceholder(height: 46, width: 46),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('UP NEXT',
                              style: t.overlineStyle.copyWith(color: accentColor)),
                          const SizedBox(height: 2),
                          Text(
                            '${nextExercise.name} · ${nextExercise.reps} reps',
                            style: t.hankenGrotesk(size: 13, weight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestRingPainter extends CustomPainter {
  _RestRingPainter({required this.progress});
  final double progress;

  static const _circumference = 2 * math.pi * 90.0; // radius = 90

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 90.0;
    const stroke = 10.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, trackPaint);

    final arcPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RestRingPainter old) => old.progress != progress;
}
```

**Commit:**
```bash
git add lib/screens/workout/rest_screen.dart
git commit -m "feat: implement Rest screen with countdown ring, +15s, Skip, Up Next card"
```

---

## Task 14: Workout Complete Screen

**Files:**
- Create: `lib/screens/workout/complete_screen.dart`

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/session_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_button.dart';

class CompleteScreen extends ConsumerStatefulWidget {
  const CompleteScreen({super.key});
  @override
  ConsumerState<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends ConsumerState<CompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringCtrl;
  bool _awarded = false;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100));
    _ringCtrl.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _award());
  }

  void _award() {
    if (_awarded) return;
    _awarded = true;
    final session = ref.read(sessionProvider);
    if (session.workout != null) {
      ref.read(userProvider.notifier).addXp(session.workout!.xpReward);
      ref.read(userProvider.notifier).incrementStreak();
      ref.read(userProvider.notifier).incrementWorkouts();
    }
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final user    = ref.watch(userProvider);
    final workout = session.workout;

    final elapsedSec = session.elapsedSeconds;
    final totalReps  = session.completedSets.fold(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            children: [
              // Animated badge
              AnimatedBuilder(
                animation: _ringCtrl,
                builder: (_, __) => SizedBox(
                  width: 104, height: 104,
                  child: CustomPaint(
                    painter: _BadgeRingPainter(progress: _ringCtrl.value),
                    child: Center(
                      child: Container(
                        width: 54, height: 54,
                        decoration: const BoxDecoration(
                          gradient: accentGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.check, color: onAccent, size: 28),
                        ),
                      )
                          .animate(delay: 500.ms)
                          .scale(begin: const Offset(0.4, 0.4), end: const Offset(1, 1),
                              duration: 500.ms, curve: Curves.elasticOut)
                          .fadeIn(duration: 300.ms),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Workout complete!',
                  style: t.screenTitle, textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(
                'Nice work, ${user.name.split(' ').first}. ${workout?.title ?? ''} done.',
                style: t.bodyStyle, textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Summary triplet
              Row(children: [
                _SummaryTile(label: 'Duration', value: _fmtDur(elapsedSec)),
                const SizedBox(width: 8),
                _SummaryTile(label: 'Total reps', value: '$totalReps'),
                const SizedBox(width: 8),
                _SummaryTile(
                  label: 'XP',
                  value: '+${workout?.xpReward ?? 0}',
                  valueColor: accentColor,
                ),
              ]),
              const SizedBox(height: 14),
              // Streak banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: accentGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: onAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Streak extended!',
                              style: t.hankenGrotesk(
                                  size: 11, weight: FontWeight.w700, color: onAccentDim)),
                          const SizedBox(height: 2),
                          Text(
                            '${user.streak - 1} → ${user.streak} days',
                            style: t.hankenGrotesk(
                                size: 13, weight: FontWeight.w700, color: onAccent),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text('${user.streak}',
                        style: t.bigNumber.copyWith(color: onAccent)),
                  ],
                ),
              ),
              const Spacer(),
              PushPrimaryButton(
                label: 'Finish',
                onTap: () {
                  ref.read(sessionProvider.notifier).discard();
                  context.go('/home');
                },
              ),
              const SizedBox(height: 10),
              PushGhostButton(
                label: 'Share progress',
                onTap: () {}, // TODO: share sheet
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDur(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: surfaceColor, borderRadius: BorderRadius.circular(13)),
      child: Column(children: [
        Text(value,
            style: t.statValue.copyWith(color: valueColor)),
        const SizedBox(height: 2),
        Text(label, style: t.metaStyle),
      ]),
    ),
  );
}

class _BadgeRingPainter extends CustomPainter {
  _BadgeRingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 48.0;
    const stroke = 6.0;

    canvas.drawCircle(center, radius,
        Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = stroke);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_BadgeRingPainter old) => old.progress != progress;
}
```

**Commit:**
```bash
git add lib/screens/workout/complete_screen.dart
git commit -m "feat: implement Workout Complete screen with animated badge ring, streak banner"
```

---

## Task 15: Progress Screen

**Files:**
- Create: `lib/screens/progress/progress_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/progress_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart' as t;
import '../../widgets/push_progress_bar.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _restDayIndices = {3}; // Thursday = rest day in seed data

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user     = ref.watch(userProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Progress', style: t.screenTitle),
              const SizedBox(height: 13),
              // Streak hero
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: accentGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user.streak}',
                            style: t.bigNumber.copyWith(color: onAccent)),
                        Text('DAY STREAK',
                            style: t.overlineStyle.copyWith(color: onAccentDim)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Best ${user.bestStreak}',
                            style: t.hankenGrotesk(
                                size: 12, weight: FontWeight.w700, color: onAccentDim)),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(4, (i) => Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Container(
                              width: 4, height: 16,
                              decoration: BoxDecoration(
                                color: i < 3 ? onAccent : const Color(0x60000000),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              // Weekly bar chart
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reps this week',
                        style: t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 78,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (i) {
                          final isRest = _restDayIndices.contains(i);
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FractionallySizedBox(
                                          heightFactor: progress.weeklyReps[i],
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isRest ? trackMuted : accentColor,
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(7, (i) => Expanded(
                        child: Center(
                          child: Text(_dayLabels[i], style: t.metaStyle.copyWith(fontSize: 9)),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              // Stat triplet
              Row(children: [
                _StatTile(label: 'Total reps',  value: '${progress.totalReps ~/ 1000}k'),
                const SizedBox(width: 8),
                _StatTile(label: 'Workouts',    value: '${user.totalWorkouts}'),
                const SizedBox(width: 8),
                _StatTile(label: 'Trained',     value: '${progress.trainedHours.round()}h'),
              ]),
              const SizedBox(height: 13),
              // Personal bests
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personal bests',
                        style: t.hankenGrotesk(size: 13, weight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    ...progress.personalBests.map((pb) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(pb.exercise,
                                  style: t.hankenGrotesk(size: 12, weight: FontWeight.w600)),
                              Text('${pb.value} ${pb.unit}'.trim(),
                                  style: t.hankenGrotesk(
                                      size: 12, weight: FontWeight.w700, color: accentColor)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          PushProgressBar(value: pb.percentage, height: 4),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: surfaceColor, borderRadius: BorderRadius.circular(13)),
      child: Column(children: [
        Text(value, style: t.statValue),
        const SizedBox(height: 2),
        Text(label, style: t.metaStyle),
      ]),
    ),
  );
}
```

**Commit:**
```bash
git add lib/screens/progress/
git commit -m "feat: implement Progress screen with streak hero, weekly bar chart, personal bests"
```

---

## Task 16: Final Wiring + Smoke Test

**Step 1: Update router imports** — replace `_stubs.dart` imports in `router.dart` with real screen imports (one import per screen file).

**Step 2: Delete `lib/screens/_stubs.dart`**

**Step 3: Build release APK**
```bash
flutter build apk --release 2>&1 | tail -10
```
Expected: `Built build/app/outputs/flutter-apk/app-release.apk`

**Step 4: Run all tests**
```bash
flutter test
```
Expected: all pass, 0 failures.

**Step 5: Final commit**
```bash
git add -A
git commit -m "feat: wire all 8 screens — PUSH app complete"
```

---

## Checklist

- [ ] Task 1: Flutter project + git
- [ ] Task 2: Design tokens (colors + typography)
- [ ] Task 3: ThemeData light/dark + PushColors extension
- [ ] Task 4: Models (User, Exercise, Workout, Progress)
- [ ] Task 5: Riverpod providers (theme, user, session, library, progress)
- [ ] Task 6: Router (go_router + ShellRoute) + stub screens
- [ ] Task 7: Shared widgets (nav, buttons, placeholder, progress bar, streak dot, early exit sheet)
- [ ] Task 8: Onboarding screen
- [ ] Task 9: Home screen
- [ ] Task 10: Library screen
- [ ] Task 11: Profile screen (with theme toggle)
- [ ] Task 12: Active Workout screen
- [ ] Task 13: Rest Timer screen
- [ ] Task 14: Workout Complete screen
- [ ] Task 15: Progress & Stats screen
- [ ] Task 16: Final wiring + smoke test
