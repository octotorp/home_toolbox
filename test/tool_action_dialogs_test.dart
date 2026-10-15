import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_toolbox/core/constants/app_constants.dart';
import 'package:home_toolbox/core/theme/app_theme.dart';
import 'package:home_toolbox/models/tool_item.dart';
import 'package:home_toolbox/screens/tools/tools_list_screen.dart';
import 'package:home_toolbox/screens/tools/tool_detail_screen.dart';

void main() {
  setUp(() {
    AppConstants.resetTools();
  });

  testWidgets('Test Loan and Return flow in ToolsListScreen widescreen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1100, 750);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ToolsListScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Find and tap "Видати" button
    final loanButtonFinder = find.widgetWithText(ElevatedButton, 'Видати');
    expect(loanButtonFinder, findsOneWidget);
    await tester.tap(loanButtonFinder);
    await tester.pumpAndSettle();

    // Verify dialog opened
    expect(find.text('Термін позики (днів)'), findsOneWidget);

    // Tap "Видати інструмент" in dialog
    final confirmButton = find.widgetWithText(ElevatedButton, 'Видати інструмент');
    expect(confirmButton, findsOneWidget);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    // Now button should say "Повернути"
    expect(find.widgetWithText(ElevatedButton, 'Повернути'), findsOneWidget);

    // Tap "Повернути"
    await tester.tap(find.widgetWithText(ElevatedButton, 'Повернути'));
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.text('Повернення інструмента'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Підтвердити повернення'));
    await tester.pumpAndSettle();

    // Button should be back to "Видати"
    expect(find.widgetWithText(ElevatedButton, 'Видати'), findsOneWidget);
  });

  testWidgets('Test Edit flow in ToolsListScreen widescreen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1100, 750);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ToolsListScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Find and tap "Редагувати" button
    final editButtonFinder = find.widgetWithText(OutlinedButton, 'Редагувати');
    expect(editButtonFinder, findsOneWidget);
    await tester.tap(editButtonFinder);
    await tester.pumpAndSettle();

    // Verify dialog opened
    expect(find.text('Редагувати інструмент'), findsOneWidget);

    // Change tool name
    final nameField = find.widgetWithText(TextFormField, 'Дриль ударний Bosch GSB 13 RE');
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, 'Дриль ударний Bosch PRO X');

    // Tap "Зберегти зміни"
    final saveButton = find.widgetWithText(ElevatedButton, 'Зберегти зміни');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify updated title on screen
    expect(find.text('Дриль ударний Bosch PRO X'), findsWidgets);
  });
}
