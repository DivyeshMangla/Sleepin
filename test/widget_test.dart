import 'package:flutter_test/flutter_test.dart';

import 'package:sleepin/app.dart';

void main() {
  testWidgets('App loads without error', (WidgetTester tester) async {
    await tester.pumpWidget(const SleepinApp());
    expect(find.text('Welcome to Sleepin'), findsOneWidget);
  });
}
