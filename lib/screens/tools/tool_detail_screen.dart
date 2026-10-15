import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/tool_item.dart';

/// Екран детальної інформації про інструмент (S-09, FR-10, image7.png)
class ToolDetailScreen extends StatelessWidget {
  final ToolItem tool;

  const ToolDetailScreen({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          tool.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Редагування інструмента')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Видалення інструмента')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Блок зображення / заглушки фото (image7.png)
                Container(
                  height: 180,
                  color: const Color(0xFFBFD8D5),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 60,
                      color: AppTheme.primaryTeal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Назва інструмента
                      Text(
                        tool.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C1C),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Бейджі: Стан та Статус
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDE7E5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tool.condition,
                              style: const TextStyle(
                                color: Color(0xFF2A3A38),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: tool.status == ToolStatus.available
                                  ? AppTheme.statusAvailableBg
                                  : (tool.status == ToolStatus.loaned
                                      ? AppTheme.statusLoanedBg
                                      : AppTheme.statusRepairBg),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tool.statusTitle,
                              style: TextStyle(
                                color: tool.status == ToolStatus.available
                                    ? AppTheme.statusAvailableColor
                                    : (tool.status == ToolStatus.loaned
                                        ? AppTheme.statusLoanedColor
                                        : AppTheme.statusRepairColor),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Поля метаданих
                      _buildInfoRow(
                        icon: Icons.build_outlined,
                        label: 'Категорія',
                        value: tool.category,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Придбано',
                        value: tool.purchaseDate ?? '14.03.2023',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Місце зберігання',
                        value: tool.location,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.edit_note_outlined,
                        label: 'Нотатки',
                        value: tool.notes ?? 'Комплект свердел у кейсі',
                      ),
                      const SizedBox(height: 28),

                      // Кнопки дій
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Форма видачі інструмента')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryTeal,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              icon: const Icon(Icons.swap_horiz_rounded),
                              label: const Text(
                                'Видати',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Зміна стану інструмента')),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryTeal,
                                side: const BorderSide(color: AppTheme.primaryTeal, width: 1.5),
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Змінити стан',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Історія використання
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Історія використання',
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
                              'Усі',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Запис історії
                      Row(
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
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Повернено · стан: добрий',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191C1C),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Сусід Андрій · 12.09.2026',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF52605E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pop();
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryTeal),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF52605E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF191C1C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
