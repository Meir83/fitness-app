import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';

final _allWorkouts = [Workout.foundationsPush];

final libraryFilterProvider = StateProvider<String>((ref) => 'Skills');

final workoutsProvider = Provider<List<Workout>>((ref) => _allWorkouts);
