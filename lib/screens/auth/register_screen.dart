import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../home/home_dashboard_screen.dart';

/// Екран реєстрації нового користувача (S-02, FR-01, image2.png)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController(text: 'Влад');
  final _lastNameController = TextEditingController(text: 'Прокопів');
  final _emailController = TextEditingController(text: 'vlad@example.com');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Реєстрація',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _firstNameController,
                      label: "Ім'я",
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _lastNameController,
                      label: 'Прізвище',
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _emailController,
                      label: 'Електронна пошта',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Пароль',
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmPasswordController,
                      label: 'Повторіть пароль',
                      isPassword: true,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Мінімум 8 символів, літери та цифри',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF52605E),
                      ),
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      text: 'Зареєструватися',
                      isLoading: _isLoading,
                      onPressed: _handleRegister,
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Вже маєте акаунт?',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF52605E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primaryTeal,
                            ),
                            child: const Text(
                              'Увійти',
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
