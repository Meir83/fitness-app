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

  static const ProgressModel seed = ProgressModel(
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
