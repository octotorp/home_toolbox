import 'package:flutter/material.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';

/// Екран зміни пароля авторизованого користувача (S-04, FR-05)
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пароль успішно змінено!'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Зміна пароля'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Безпека облікового запису',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191C1C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Для зміни пароля підтвердіть поточний пароль та введіть новий',
                    style: TextStyle(color: Color(0xFF6F7978)),
                  ),
                  const SizedBox(height: 24),

                  AppTextField(
                    controller: _currentPasswordController,
                    label: 'Поточний пароль',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_clock_outlined,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _newPasswordController,
                    label: 'Новий пароль',
                    hint: 'Не менше 8 символів',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _confirmPasswordController,
                    label: 'Підтвердження нового пароля',
                    hint: 'Повторіть новий пароль',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 28),

                  PrimaryButton(
                    text: 'Зберегти пароль',
                    icon: Icons.check,
                    isLoading: _isLoading,
                    onPressed: _handleChangePassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
