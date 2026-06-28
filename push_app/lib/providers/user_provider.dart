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
