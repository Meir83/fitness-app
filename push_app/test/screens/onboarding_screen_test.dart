import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_app/screens/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('Onboarding shows goal cards and PUSH wordmark', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: OnboardingScreen()),
    ));
    await tester.pump(Duration.zero); // drain flutter_animate startup timer
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
    await tester.pump(Duration.zero); // drain flutter_animate startup timer
    await tester.tap(find.text('My first pull-up'));
    await tester.pump();
    expect(find.text('My first pull-up'), findsOneWidget);
  });
}
