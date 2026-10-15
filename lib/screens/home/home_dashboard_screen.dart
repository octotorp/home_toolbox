import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_navigation_rail.dart';
import '../../core/widgets/stat_card.dart';
import '../../models/tool_item.dart';
import '../locations/storage_locations_screen.dart';
import '../profile/profile_screen.dart';
import '../tools/tools_list_screen.dart';
import '../tools/tool_detail_screen.dart';

/// Головний екран (Dashboard) застосунку (S-05 мобільний, S-06 веб/десктоп, FR-08)
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _navIndex = 0;

  void _onRailSelect(int index) {
    if (index == _navIndex) return;
    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const ToolsListScreen()),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const StorageLocationsScreen()),
      );
    } else if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const ProfileScreen()),
      );
    }
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

  // --- 1. АЛЬБОМНИЙ / ВЕБ / НОУТБУК МАКЕТ ---
  Widget _buildWidescreenLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            AppNavigationRail(
              selectedIndex: 0,
              onDestinationSelected: _onRailSelect,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Верхній бар: Заголовок, пошук та профіль
                    Row(
                      children: [
                        const Text(
                          'Домашня комора',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191C1C),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) => const ToolsListScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8EFEF),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.search, color: Color(0xFF52605E), size: 22),
                                  SizedBox(width: 10),
                                  Text(
                                    'Пошук інструмента або місця зберігання...',
                                    style: TextStyle(
                                      color: Color(0xFF52605E),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD1EAE5),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'В',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF191C1C),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Статистичні картки на всю ширину
                    Row(
                      children: [
                        StatCard(
                          title: 'Усього інструментів',
                          count: '24',
                          backgroundColor: AppTheme.statTotalBg,
                          textColor: AppTheme.statTotalText,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => const ToolsListScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        StatCard(
                          title: 'Видано у позику',
                          count: '3',
                          backgroundColor: AppTheme.statLoanedBg,
                          textColor: AppTheme.statLoanedText,
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
                        const SizedBox(width: 16),
                        StatCard(
                          title: 'Потребують ремонту',
                          count: '2',
                          backgroundColor: AppTheme.statRepairBg,
                          textColor: AppTheme.statRepairText,
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
                    const SizedBox(height: 28),

                    // Швидкі дії
                    Row(
                      children: [
                        const Text(
                          'Швидкі дії:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191C1C),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Форма додавання інструмента')),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Додати інструмент'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Форма видачі інструмента')),
                            );
                          },
                          icon: const Icon(Icons.swap_horiz_rounded),
                          label: const Text('Видати сусіду'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => const StorageLocationsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.location_on_outlined),
                          label: const Text('Місця зберігання'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Двоколонковий вміст на десктопі: Видано зараз та Остання історія
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ліва половина: Видано зараз
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE2EBE9)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Видано зараз',
                                      style: TextStyle(
                                        fontSize: 18,
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
                                const SizedBox(height: 12),
                                _buildLoanedItem(
                                  title: 'Шуруповерт Makita',
                                  subtitle: 'Сусід Андрій · з 22.09',
                                  daysText: '7 днів',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (context) => ToolDetailScreen(
                                          tool: AppConstants.mockTools[1],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                _buildLoanedItem(
                                  title: 'Драбина алюмінієва',
                                  subtitle: 'Брат Олег · з 28.08',
                                  daysText: '32 дні',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (context) => ToolDetailScreen(
                                          tool: AppConstants.mockTools[5],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Права половина: Остання історія
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE2EBE9)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Остання історія',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF191C1C),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text('Вся історія'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildHistoryItem(
                                  title: 'Дриль ударний Bosch',
                                  subtitle: 'Повернено · стан: добрий',
                                  dateText: '12.09.2026',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (context) => ToolDetailScreen(
                                          tool: AppConstants.mockTools[0],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                _buildHistoryItem(
                                  title: 'Болгарка 125 мм',
                                  subtitle: 'Передано в сервіс · заміна щіток',
                                  dateText: '05.09.2026',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (context) => ToolDetailScreen(
                                          tool: AppConstants.mockTools[4],
                                        ),
                                      ),
                                    );
                                  },
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

  // --- 2. МОБІЛЬНИЙ МАКЕТ (image5.png) ---
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхній рядок: Назва застосунку та аватар
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Домашня комора',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191C1C),
                      letterSpacing: -0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1EAE5),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'В',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191C1C),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Пошуковий рядок (pill)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const ToolsListScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EFEF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Color(0xFF52605E), size: 22),
                      SizedBox(width: 10),
                      Text(
                        'Пошук інструмента',
                        style: TextStyle(
                          color: Color(0xFF52605E),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Статистичні картки (24 Усього, 3 Видано, 2 Ремонт)
              Row(
                children: [
                  StatCard(
                    title: 'Усього',
                    count: '24',
                    backgroundColor: AppTheme.statTotalBg,
                    textColor: AppTheme.statTotalText,
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
                    count: '3',
                    backgroundColor: AppTheme.statLoanedBg,
                    textColor: AppTheme.statLoanedText,
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
                    title: 'Ремонт',
                    count: '2',
                    backgroundColor: AppTheme.statRepairBg,
                    textColor: AppTheme.statRepairText,
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
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Форма додавання інструмента')),
                        );
                      },
                      child: const Text('Додати'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Форма видачі інструмента')),
                        );
                      },
                      child: const Text('Видати'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const StorageLocationsScreen(),
                          ),
                        );
                      },
                      child: const Text('Місця'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Секція: Видано зараз
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
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryTeal,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Усі',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              _buildLoanedItem(
                title: 'Шуруповерт Makita',
                subtitle: 'Сусід Андрій · з 22.09',
                daysText: '7 днів',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => ToolDetailScreen(
                        tool: AppConstants.mockTools[1],
                      ),
                    ),
                  );
                },
              ),
              _buildLoanedItem(
                title: 'Драбина алюмінієва',
                subtitle: 'Брат Олег · з 28.08',
                daysText: '32 дні',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => ToolDetailScreen(
                        tool: AppConstants.mockTools[5],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Секція: Остання історія
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Остання історія',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF191C1C),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryTeal,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Уся',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              _buildHistoryItem(
                title: 'Дриль ударний Bosch',
                subtitle: 'Повернено · стан: добрий',
                dateText: '12.09',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => ToolDetailScreen(
                        tool: AppConstants.mockTools[0],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.primaryTeal,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryTeal.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Форма додавання нового інструмента')),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (index) {
          setState(() => _navIndex = index);
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const ToolsListScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const StorageLocationsScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const ProfileScreen(),
              ),
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

  Widget _buildLoanedItem({
    required String title,
    required String subtitle,
    required String daysText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCDEDA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.build_rounded,
                  color: AppTheme.primaryTeal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF52605E),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.statusLoanedBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  daysText,
                  style: const TextStyle(
                    color: AppTheme.statusLoanedColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String subtitle,
    required String dateText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1EAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.swap_horiz_rounded,
                  color: AppTheme.primaryTeal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF52605E),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCDEDA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  dateText,
                  style: const TextStyle(
                    color: Color(0xFF191C1C),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
