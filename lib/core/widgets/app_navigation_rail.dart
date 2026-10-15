import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Фірмова бічна панель навігації для десктопного/ноутбучного режиму (image12.png).
/// Використовується на всіх екранах застосунку при ширині екрана >= 850 dp.
class AppNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback? onAddPressed;

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: const BoxDecoration(
        color: AppTheme.scaffoldBackgroundColor,
        border: Border(right: BorderSide(color: Color(0xFFE2EBE9), width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Фірмова заокруглена кнопка "+" угорі
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppTheme.primaryTeal,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryTeal.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: onAddPressed ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Форма додавання нового інструмента')),
                    );
                  },
            ),
          ),
          const SizedBox(height: 36),

          // Елементи навігації
          _buildItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Головна',
            isSelected: selectedIndex == 0,
            onTap: () => onDestinationSelected(0),
          ),
          const SizedBox(height: 20),
          _buildItem(
            icon: Icons.build_rounded,
            selectedIcon: Icons.build_rounded,
            label: 'Інструм.',
            isSelected: selectedIndex == 1,
            onTap: () => onDestinationSelected(1),
          ),
          const SizedBox(height: 20),
          _buildItem(
            icon: Icons.location_on_outlined,
            selectedIcon: Icons.location_on,
            label: 'Місця',
            isSelected: selectedIndex == 2,
            onTap: () => onDestinationSelected(2),
          ),
          const SizedBox(height: 20),
          _buildItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'Профіль',
            isSelected: selectedIndex == 3,
            onTap: () => onDestinationSelected(3),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFCCDEDA) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppTheme.primaryTeal : const Color(0xFF52605E),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppTheme.primaryTeal : const Color(0xFF52605E),
            ),
          ),
        ],
      ),
    );
  }
}
