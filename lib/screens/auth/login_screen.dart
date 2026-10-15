import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../home/home_dashboard_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

/// Екран авторизації користувача (S-01, FR-02, image1.png)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'vlad@example.com');
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) => const HomeDashboardScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Кругла емблема застосунку (image1.png)
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD1EAE5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.build_rounded,
                          color: AppTheme.primaryTeal,
                          size: 44,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Назва застосунку
                    const Text(
                      'Домашня комора',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C1C),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Каталог домашніх інструментів',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF52605E),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Поле введення Email
                    AppTextField(
                      controller: _emailController,
                      label: 'Електронна пошта',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),

                    // Поле введення Пароля
                    AppTextField(
                      controller: _passwordController,
                      label: 'Пароль',
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),

                    // Забули пароль
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryTeal,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Забули пароль?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Кнопка Увійти
                    PrimaryButton(
                      text: 'Увійти',
                      isLoading: _isLoading,
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(height: 48),

                    // Немає акаунта? Створити акаунт
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Немає акаунта?',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF52605E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryTeal,
                            ),
                            child: const Text(
                              'Створити акаунт',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
