import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:partookzan/core/theme/app_theme.dart';

void main() {
  testWidgets('App theme builds a MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const Scaffold(body: Text('PartookZan')),
      ),
    );

    expect(find.text('PartookZan'), findsOneWidget);
  });
}
