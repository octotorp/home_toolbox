import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/tool_card.dart';
import '../../models/tool_item.dart';
import '../profile/profile_screen.dart';
import '../tools/tools_list_screen.dart';
import '../tools/tool_detail_screen.dart';

/// Головний екран (Dashboard) застосунку (S-05/S-06, FR-08)
/// Реалізує зведені показники, швидкі дії та переходи між основними функціями
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentNavIndex = 0;

  // Відповідно до вимог Лаб 3 (п. 4.2): Hardcoded-дані користувача для відображення
  static const String _userName = 'Владислав Прокопів';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primarySeedColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.home_repair_service_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Home Toolbox',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Пошук інструментів',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const ToolsListScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primarySeedColor,
              child: const Text(
                'ВП',
                style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            tooltip: 'Профіль користувача',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Блок привітання користувача
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF006A6A), Color(0xFF004D40)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primarySeedColor.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Вітаємо, $_userName!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'У вашій домашній майстерні порядок. 2 інструменти зараз позичені сусідам.',
                              style: TextStyle(
                                color: Color(0xFFE0F2F1),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.handyman_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Зведені показники (StatCards)
                const Text(
                  'Статистика майстерні',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191C1C),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    StatCard(
                      title: 'Усього',
                      count: '${AppConstants.mockTools.length}',
                      icon: Icons.inventory_2_outlined,
                      backgroundColor: Colors.white,
                      iconColor: AppTheme.primarySeedColor,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const ToolsListScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    StatCard(
                      title: 'Видано',
                      count: '2',
                      icon: Icons.outbox_rounded,
                      backgroundColor: AppTheme.statusLoanedBg,
                      iconColor: AppTheme.statusLoanedColor,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const ToolsListScreen(
                              initialFilterStatus: ToolStatus.loaned,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    StatCard(
                      title: 'В ремонті',
                      count: '1',
                      icon: Icons.build_circle_outlined,
                      backgroundColor: AppTheme.statusRepairBg,
                      iconColor: AppTheme.statusRepairColor,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const ToolsListScreen(
                              initialFilterStatus: ToolStatus.inRepair,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Швидкі дії
                const Text(
                  'Швидкі дії',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191C1C),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionBtn(
                        context: context,
                        icon: Icons.add_circle_outline,
                        label: 'Додати',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Форма додавання інструмента')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildQuickActionBtn(
                        context: context,
                        icon: Icons.outbox_rounded,
                        label: 'Видати',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Форма видачі інструмента в позику')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildQuickActionBtn(
                        context: context,
                        icon: Icons.folder_outlined,
                        label: 'Місця',
                        onTap: () {
                          _showLocationsModal(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Блок "Видано зараз"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Видано зараз',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C1C),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const ToolsListScreen(
                              initialFilterStatus: ToolStatus.loaned,
                            ),
                          ),
                        );
                      },
                      child: const Text('Всі видані'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...AppConstants.mockTools
                    .where((t) => t.status == ToolStatus.loaned)
                    .map((t) => ToolCard(
                          tool: t,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => ToolDetailScreen(tool: t),
                              ),
                            );
                          },
                        )),

                const SizedBox(height: 16),

                // Блок "Останні інструменти"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Каталог інструментів',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C1C),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const ToolsListScreen(),
                          ),
                        );
                      },
                      child: const Text('Переглянути всі'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...AppConstants.mockTools
                    .take(3)
                    .map((t) => ToolCard(
                          tool: t,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => ToolDetailScreen(tool: t),
                              ),
                            );
                          },
                        )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const ToolsListScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const ProfileScreen(),
              ),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Головна',
          ),
          NavigationDestination(
            icon: Icon(Icons.handyman_outlined),
            selectedIcon: Icon(Icons.handyman),
            label: 'Каталог',
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

  Widget _buildQuickActionBtn({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E3E3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primarySeedColor, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191C1C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationsModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Місця зберігання інструментів',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...AppConstants.storageLocations.map(
              (loc) => ListTile(
                leading: const Icon(Icons.location_on, color: AppTheme.primarySeedColor),
                title: Text(loc),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const ToolsListScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
