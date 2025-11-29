import 'package:flutter_test/flutter_test.dart';

import 'package:sleepin/main.dart';

void main() {
  testWidgets('App loads without error', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Welcome to Sleepin'), findsOneWidget);
  });
}
