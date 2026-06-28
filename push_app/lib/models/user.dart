enum PushBadge { sevenDay, hundredReps, earlyBird, pullUp, thirtyDay }

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
  final List<PushBadge> earnedBadges;
  final DateTime joinDate;
  final String selectedGoal;

  int get levelNumber => level.index + 1;

  UserModel copyWith({
    String? name, UserLevel? level, int? xp, int? xpToNext,
    int? streak, int? bestStreak, int? totalWorkouts,
    List<PushBadge>? earnedBadges, DateTime? joinDate, String? selectedGoal,
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
    earnedBadges: [PushBadge.sevenDay, PushBadge.hundredReps, PushBadge.earlyBird],
    joinDate: DateTime(2026, 3, 1),
    selectedGoal: 'Build real strength',
  );
}
