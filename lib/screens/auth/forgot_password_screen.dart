import 'package:flutter/material.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';

/// Екран відновлення пароля через електронну пошту (S-03, FR-03)
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController(text: 'vlad.prokopiv@lpnu.ua');
  bool _isLoading = false;
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleReset() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Відновлення пароля'),
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
                  const Icon(
                    Icons.mark_email_read_outlined,
                    size: 64,
                    color: Color(0xFF006A6A),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Забули свій пароль?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191C1C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Вкажіть адресу електронної пошти, привʼязану до вашого акаунту. Ми надішлемо вам інструкцію для скидання пароля.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF6F7978)),
                  ),
                  const SizedBox(height: 28),

                  if (!_isSent) ...[
                    AppTextField(
                      controller: _emailController,
                      label: 'Електронна пошта',
                      hint: 'example@domain.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: 'Надіслати посилання',
                      icon: Icons.send_rounded,
                      isLoading: _isLoading,
                      onPressed: _handleReset,
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Посилання для відновлення надіслано на ${_emailController.text}!',
                              style: const TextStyle(
                                color: Color(0xFF1B5E20),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Повернутися до входу'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
