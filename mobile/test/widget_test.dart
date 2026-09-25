import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:e_sumbong/screens/landing/landing_screen.dart';

void main() {
  testWidgets('landing screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LandingScreen()));

    expect(find.text('E-Sumbong'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
