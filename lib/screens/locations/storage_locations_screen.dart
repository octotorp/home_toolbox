import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_navigation_rail.dart';
import '../home/home_dashboard_screen.dart';
import '../profile/profile_screen.dart';
import '../tools/tools_list_screen.dart';

class LocationInfo {
  final String title;
  final String subtitle;
  final int count;

  const LocationInfo({
    required this.title,
    required this.subtitle,
    required this.count,
  });
}

/// Екран місць зберігання (S-11, image11.png) з адаптивною підтримкою мобільного та десктопного режимів.
class StorageLocationsScreen extends StatefulWidget {
  const StorageLocationsScreen({super.key});

  @override
  State<StorageLocationsScreen> createState() => _StorageLocationsScreenState();
}

class _StorageLocationsScreenState extends State<StorageLocationsScreen> {
  final List<LocationInfo> _locations = const [
    LocationInfo(
      title: 'Гараж',
      subtitle: 'Стелаж А, стелаж Б, верстак',
      count: 9,
    ),
    LocationInfo(
      title: 'Комора',
      subtitle: 'Ящик 1, ящик 2',
      count: 6,
    ),
    LocationInfo(
      title: 'Балкон',
      subtitle: 'Шафа біля вікна',
      count: 3,
    ),
    LocationInfo(
      title: 'Підвал',
      subtitle: 'Металева шафа',
      count: 4,
    ),
  ];

  int _navIndex = 2;

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

  Widget _buildWidescreenLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            AppNavigationRail(
              selectedIndex: 2,
              onDestinationSelected: _onRailSelect,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Місця зберігання',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191C1C),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Додавання нового місця зберігання')),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Додати місце'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.8,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: _locations.length,
                      itemBuilder: (context, index) {
                        final loc = _locations[index];
                        return _buildLocationCard(loc);
                      },
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

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Місця зберігання',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: _locations.length,
          itemBuilder: (context, index) {
            final loc = _locations[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildLocationCard(loc),
            );
          },
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Додавання нового місця зберігання')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryTeal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
        icon: const Icon(Icons.add, size: 22),
        label: const Text(
          'Додати місце',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (index) {
          if (index == _navIndex) return;
          setState(() => _navIndex = index);
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (context) => const HomeDashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (context) => const ToolsListScreen()),
            );
          } else if (index == 3) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (context) => const ProfileScreen()),
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

  Widget _buildLocationCard(LocationInfo loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F2F0),
        borderRadius: BorderRadius.circular(16),
      ),
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
              Icons.location_on_rounded,
              color: AppTheme.primaryTeal,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loc.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191C1C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF52605E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD1EAE5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${loc.count} інстр.',
              style: const TextStyle(
                color: AppTheme.primaryTeal,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
