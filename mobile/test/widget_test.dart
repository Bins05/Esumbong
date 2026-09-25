import 'package:flutter_test/flutter_test.dart';

import 'package:e_sumbong/app.dart';

void main() {
  testWidgets('setup screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ESumbongApp());

    expect(find.text('E-Sumbong - Setup Complete'), findsOneWidget);
  });
}
