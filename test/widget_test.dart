import 'package:flutter_test/flutter_test.dart';
import 'package:home_toolbox/main.dart';
import 'package:home_toolbox/screens/auth/login_screen.dart';

void main() {
  testWidgets('HomeToolboxApp smoke test', (WidgetTester tester) async {
    // Побудова застосунку
    await tester.pumpWidget(const HomeToolboxApp());

    // Перевірка наявності екрана авторизації та заголовка "Домашня комора"
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Домашня комора'), findsOneWidget);
    expect(find.text('Увійти'), findsOneWidget);
  });
}
