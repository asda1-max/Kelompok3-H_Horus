// ============================================================
// widget_test.dart - Test dasar untuk aplikasi Horus
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:horus/main.dart';

void main() {
  testWidgets('App launches with login page', (WidgetTester tester) async {
    // Build aplikasi dan render frame
    await tester.pumpWidget(const HorusApp());

    // Verifikasi halaman login muncul
    expect(find.text('HORUS'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
