import 'package:flutter_test/flutter_test.dart';

import 'package:controlpan/main.dart';

void main() {
  testWidgets('ControlPan inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const ControlPanApp());

    expect(find.text('ControlPan'), findsOneWidget);
  });
}	

