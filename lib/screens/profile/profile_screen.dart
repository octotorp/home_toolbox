import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_navigation_rail.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../auth/login_screen.dart';
import '../home/home_dashboard_screen.dart';
import '../locations/storage_locations_screen.dart';
import '../tools/tools_list_screen.dart';

/// Екран профілю користувача (S-17, FR-06, image4.png) з повною підтримкою десктопу та мобільного.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController(text: AppConstants.currentUser.firstName);
  final _lastNameController = TextEditingController(text: AppConstants.currentUser.lastName);
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  int _navIndex = 3;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _onRailSelect(int index) {
    if (index == _navIndex) return;
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const HomeDashboardScreen()),
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const ToolsListScreen()),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const StorageLocationsScreen()),
      );
    }
  }

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWidescreen = constraints.maxWidth >= 850;
        if (isWidescreen) {
          return _buildWidescreenLayout(context);
        }
        return _buildMobileLayout(context);
      },
    );
  }

  // --- 1. АЛЬБОМНИЙ / ВЕБ / ДЕСКТОП МАКЕТ ---
  Widget _buildWidescreenLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            AppNavigationRail(
              selectedIndex: 3,
              onDestinationSelected: _onRailSelect,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Профіль користувача',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C1C),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Дві картки поруч: Дані профілю та Безпека/пароль
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ліва картка: Дані користувача
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE2EBE9)),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 104,
                                      height: 104,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD1EAE5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'В',
                                          style: TextStyle(
                                            fontSize: 44,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF191C1C),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.primaryTeal,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        controller: _firstNameController,
                                        label: "Ім'я",
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: AppTextField(
                                        controller: _lastNameController,
                                        label: 'Прізвище',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: TextEditingController(text: AppConstants.currentUser.email),
                                  label: 'Електронна пошта',
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: TextEditingController(text: AppConstants.currentUser.phone),
                                  label: 'Номер телефону',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Права картка: Зміна пароля та Дії
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE2EBE9)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Змінити пароль (за потреби)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF191C1C),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: _currentPasswordController,
                                  label: 'Поточний пароль',
                                  isPassword: true,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  controller: _newPasswordController,
                                  label: 'Новий пароль',
                                  isPassword: true,
                                ),
                                const SizedBox(height: 24),
                                PrimaryButton(
                                  text: 'Зберегти зміни',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Дані профілю успішно оновлено!')),
                                    );
                                  },
                                ),
                                const SizedBox(height: 28),
                                const Divider(),
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: _handleLogout,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFA82222),
                                    side: const BorderSide(color: Color(0xFFA82222), width: 1.5),
                                    minimumSize: const Size.fromHeight(48),
                                  ),
                                  icon: const Icon(Icons.logout_rounded, size: 20),
                                  label: const Text(
                                    'Вийти з акаунта',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. МОБІЛЬНИЙ МАКЕТ (image4.png) ---
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Профіль',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191C1C),
                ),
              ),
              const SizedBox(height: 24),

              // Аватар з літерою "В" та іконкою камери
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1EAE5),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'В',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191C1C),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryTeal,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Рядок: Ім'я та Прізвище
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _firstNameController,
                      label: "Ім'я",
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: AppTextField(
                      controller: _lastNameController,
                      label: 'Прізвище',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Блок зміни пароля
              const Text(
                'Змінити пароль (за потреби)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191C1C),
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _currentPasswordController,
                label: 'Поточний пароль',
                isPassword: true,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _newPasswordController,
                label: 'Новий пароль',
                isPassword: true,
              ),
              const SizedBox(height: 28),

              // Кнопка Зберегти зміни
              PrimaryButton(
                text: 'Зберегти зміни',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Дані профілю успішно оновлено!')),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Кнопка Вийти з акаунта
              TextButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFA82222), size: 20),
                label: const Text(
                  'Вийти з акаунта',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA82222),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (index) {
          setState(() => _navIndex = index);
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (context) => const HomeDashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (context) => const ToolsListScreen()),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (context) => const StorageLocationsScreen()),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Головна',
          ),
          NavigationDestination(
            icon: Icon(Icons.handyman_outlined),
            selectedIcon: Icon(Icons.handyman),
            label: 'Інструменти',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: 'Місця',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}
