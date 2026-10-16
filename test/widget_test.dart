import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_toolbox/main.dart';
import 'package:home_toolbox/screens/auth/login_screen.dart';
import 'package:home_toolbox/screens/locations/storage_locations_screen.dart';
import 'package:home_toolbox/screens/tools/tools_list_screen.dart';

void main() {
  testWidgets('HomeToolboxApp smoke test', (WidgetTester tester) async {
    // Побудова застосунку
    await tester.pumpWidget(const HomeToolboxApp());

    // Перевірка наявності екрана авторизації та заголовка "Домашня комора"
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Домашня комора'), findsOneWidget);
    expect(find.text('Увійти'), findsOneWidget);
  });

  testWidgets('Mobile navigation from ToolsListScreen to StorageLocationsScreen test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: ToolsListScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Перевірка, що стрілочки назад немає на головному екрані інструментів
    expect(find.byIcon(Icons.arrow_back), findsNothing);

    // Знаходимо вкладку "Місця" у NavigationBar та натискаємо
    final locationsTab = find.text('Місця');
    expect(locationsTab, findsOneWidget);
    await tester.tap(locationsTab);
    await tester.pumpAndSettle();

    // Перевіряємо, що відкрився екран "Місця зберігання"
    expect(find.byType(StorageLocationsScreen), findsOneWidget);
    expect(find.text('Місця зберігання'), findsOneWidget);
  });
}
