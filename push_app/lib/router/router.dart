import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/workout/active_workout_screen.dart';
import '../screens/workout/complete_screen.dart';
import '../screens/workout/rest_screen.dart';
import '../widgets/push_bottom_nav.dart';
import 'package:flutter/material.dart';

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
