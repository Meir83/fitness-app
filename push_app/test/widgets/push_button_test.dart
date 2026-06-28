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
