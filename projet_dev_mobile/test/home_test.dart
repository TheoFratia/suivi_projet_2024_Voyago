import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projet_dev_mobile/screen/home_screen.dart';
import 'package:projet_dev_mobile/services/api.dart';
import 'package:mockito/mockito.dart';

class MockApiManager extends Mock implements ApiManager {}

void main() {
  MockApiManager mockApiManager;

  setUp(() {
    mockApiManager = MockApiManager();
  });

  testWidgets('Home screen should show logo', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Home screen should show destination input field', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));

    expect(find.byType(Autocomplete<String>), findsOneWidget);
  });

  testWidgets('Home screen should show random destination button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Home()));

    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}