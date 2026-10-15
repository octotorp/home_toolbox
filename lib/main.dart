import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/change_password_screen.dart';
import 'screens/home/home_dashboard_screen.dart';
import 'screens/tools/tools_list_screen.dart';
import 'screens/tools/tool_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HomeToolboxApp());
}

/// Головний віджет застосунку "Каталог домашніх інструментів" (Home Toolbox)
/// Лабораторна робота №3, Варіант 22, ст. гр. ПЗ-32 Прокопів В. І.
class HomeToolboxApp extends StatelessWidget {
  const HomeToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Підтримка прямої маршрутизації через query-параметр ?screen=... для зручного перегляду та тестування
    final initialScreen = Uri.base.queryParameters['screen'] ?? '/';

    return MaterialApp(
      title: 'Home Toolbox - Каталог домашніх інструментів',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialScreen.startsWith('/') ? initialScreen : '/$initialScreen',
      routes: {
        '/': (context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeDashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/change_password': (context) => const ChangePasswordScreen(),
        '/tools': (context) => const ToolsListScreen(),
        '/tool_detail': (context) => ToolDetailScreen(tool: AppConstants.mockTools[1]),
      },
    );
  }
}
