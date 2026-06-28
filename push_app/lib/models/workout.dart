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

  static const Workout foundationsPush = Workout(
    id: 'foundations_push',
    title: 'Foundations Push',
    durationMinutes: 28,
    difficulty: Difficulty.beginner,
    xpReward: 120,
    category: 'Push',
    exercises: [
      Exercise(id: 'pushup',       name: 'Push-ups',          muscleGroup: 'chest & triceps', sets: 3, reps: 12),
      Exercise(id: 'incline_rows', name: 'Incline rows',      muscleGroup: 'back & biceps',   sets: 3, reps: 10),
      Exercise(id: 'pike_push',    name: 'Pike push-ups',     muscleGroup: 'shoulders',       sets: 3, reps: 8),
      Exercise(id: 'dips',         name: 'Dips',              muscleGroup: 'triceps & chest', sets: 3, reps: 10),
      Exercise(id: 'plank',        name: 'Plank hold',        muscleGroup: 'core',            sets: 3, reps: 30),
      Exercise(id: 'neg_pullup',   name: 'Negative pull-ups', muscleGroup: 'back',            sets: 3, reps: 5),
    ],
  );
}
