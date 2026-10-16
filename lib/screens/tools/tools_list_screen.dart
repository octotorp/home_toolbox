import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/tool_card.dart';
import '../../models/tool_item.dart';
import '../../core/widgets/app_navigation_rail.dart';
import '../home/home_dashboard_screen.dart';
import '../locations/storage_locations_screen.dart';
import '../profile/profile_screen.dart';
import 'tool_action_dialogs.dart';
import 'tool_detail_screen.dart';

/// Адаптивний екран списку інструментів (S-07 мобільний, S-08 веб/альбомний, FR-09)
/// Повністю реалізує макет image6.png для мобільних пристроїв та image12.png для десктопу/вебу.
class ToolsListScreen extends StatefulWidget {
  final ToolStatus? initialFilterStatus;

  const ToolsListScreen({super.key, this.initialFilterStatus});

  @override
  State<ToolsListScreen> createState() => _ToolsListScreenState();
}

class _ToolsListScreenState extends State<ToolsListScreen> {
  String _selectedCategory = 'Усі';
  String _searchQuery = '';
  final _searchController = TextEditingController();
  late ToolItem _selectedTool;
  int _navIndex = 1;

  @override
  void initState() {
    super.initState();
    _selectedTool = AppConstants.tools.isNotEmpty ? AppConstants.tools.first : AppConstants.mockTools.first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ToolItem> get _filteredTools {
    return AppConstants.tools.where((tool) {
      if (widget.initialFilterStatus != null && tool.status != widget.initialFilterStatus) {
        return false;
      }
      if (_selectedCategory != 'Усі') {
        if (_selectedCategory == 'Електро' && !tool.category.contains('Електро')) return false;
        if (_selectedCategory == 'Ручні' && !tool.category.contains('Руч')) return false;
        if (_selectedCategory == 'Інше' && (tool.category.contains('Електро') || tool.category.contains('Руч'))) return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = tool.name.toLowerCase().contains(q);
        final matchesLocation = tool.location.toLowerCase().contains(q);
        return matchesName || matchesLocation;
      }
      return true;
    }).toList();
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

  // --- 1. АЛЬБОМНИЙ / ВЕБ МАКЕТ (image12.png) ---
  Widget _buildWidescreenLayout(BuildContext context) {
    final filtered = _filteredTools;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            AppNavigationRail(
              selectedIndex: 1,
              onAddPressed: () async {
                final newTool = await ToolActionDialogs.showAddToolDialog(context);
                if (newTool != null) {
                  setState(() {
                    _selectedTool = newTool;
                  });
                }
              },
              onDestinationSelected: (index) {
                if (index == 1) return;
                if (index == 0) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(builder: (context) => const HomeDashboardScreen()),
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
              },
            ),

            // Середня колонка: Список інструментів
            SizedBox(
              width: 390,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Color(0xFFE2EBE9), width: 1)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Інструменти',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C1C),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Пошук
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EFEF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Color(0xFF52605E), size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) => setState(() => _searchQuery = val),
                              decoration: const InputDecoration(
                                hintText: 'Пошук за назвою або місцем',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Чіпи фільтрів
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final cat in AppConstants.categories)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => setState(() => _selectedCategory = cat),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: _selectedCategory == cat ? const Color(0xFFCCDEDA) : Colors.transparent,
                                    border: Border.all(
                                      color: _selectedCategory == cat ? Colors.transparent : const Color(0xFF707978),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_selectedCategory == cat) ...[
                                        const Icon(Icons.check, size: 16, color: Color(0xFF004F4F)),
                                        const SizedBox(width: 4),
                                      ],
                                      Text(
                                        cat,
                                        style: TextStyle(
                                          color: _selectedCategory == cat ? const Color(0xFF004F4F) : const Color(0xFF191C1C),
                                          fontWeight: _selectedCategory == cat ? FontWeight.w600 : FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Список карток
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final isSelected = item.id == _selectedTool.id;
                          return ToolCard(
                            tool: item,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedTool = item;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Права колонка: Деталі вибраного інструмента (image12.png)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заглушка фотографії
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFD8D5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 64,
                          color: AppTheme.primaryTeal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Назва
                    Text(
                      _selectedTool.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C1C),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Бейджі
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDE7E5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _selectedTool.condition,
                            style: const TextStyle(
                              color: Color(0xFF2A3A38),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: _selectedTool.status == ToolStatus.available
                                ? AppTheme.statusAvailableBg
                                : (_selectedTool.status == ToolStatus.loaned
                                    ? AppTheme.statusLoanedBg
                                    : AppTheme.statusRepairBg),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _selectedTool.statusTitle,
                            style: TextStyle(
                              color: _selectedTool.status == ToolStatus.available
                                  ? AppTheme.statusAvailableColor
                                  : (_selectedTool.status == ToolStatus.loaned
                                      ? AppTheme.statusLoanedColor
                                      : AppTheme.statusRepairColor),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Метадані у 2 колонки (image12.png)
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetaItem(
                            icon: Icons.build_outlined,
                            label: 'Категорія',
                            value: _selectedTool.category,
                          ),
                        ),
                        Expanded(
                          child: _buildMetaItem(
                            icon: Icons.calendar_today_outlined,
                            label: 'Придбано',
                            value: _selectedTool.purchaseDate ?? '14.03.2023',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildMetaItem(
                      icon: Icons.location_on_outlined,
                      label: 'Місце зберігання',
                      value: _selectedTool.location,
                    ),
                    const SizedBox(height: 28),

                    // Рядок кнопок дій
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final updated = await ToolActionDialogs.showLoanDialog(context, _selectedTool);
                            if (updated != null) {
                              setState(() {
                                _selectedTool = updated;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          icon: Icon(_selectedTool.status == ToolStatus.loaned
                              ? Icons.assignment_return_outlined
                              : Icons.swap_horiz_rounded),
                          label: Text(
                            _selectedTool.status == ToolStatus.loaned ? 'Повернути' : 'Видати',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final updated = await ToolActionDialogs.showEditToolDialog(context, _selectedTool);
                            if (updated != null) {
                              setState(() {
                                _selectedTool = updated;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryTeal,
                            side: const BorderSide(color: AppTheme.primaryTeal, width: 1.5),
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Редагувати', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final deleted = await ToolActionDialogs.showDeleteDialog(context, _selectedTool);
                            if (deleted) {
                              setState(() {
                                _selectedTool = AppConstants.tools.isNotEmpty
                                    ? AppConstants.tools.first
                                    : AppConstants.mockTools.first;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFA82222),
                            side: const BorderSide(color: Color(0xFFA82222), width: 1.5),
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Видалити', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Історія використання
                    const Text(
                      'Історія використання',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C1C),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                  fontSize: 16,
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
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. МОБІЛЬНИЙ МАКЕТ (image6.png) ---
  Widget _buildMobileLayout(BuildContext context) {
    final filtered = _filteredTools;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Інструменти',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Пошук
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EFEF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF52605E), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: const InputDecoration(
                          hintText: 'Пошук за назвою або місцем',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Чіпи категорій
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final cat in AppConstants.categories)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() => _selectedCategory = cat),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedCategory == cat ? const Color(0xFFCCDEDA) : Colors.transparent,
                              border: Border.all(
                                color: _selectedCategory == cat ? Colors.transparent : const Color(0xFF707978),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_selectedCategory == cat) ...[
                                  const Icon(Icons.check, size: 16, color: Color(0xFF004F4F)),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  cat,
                                  style: TextStyle(
                                    color: _selectedCategory == cat ? const Color(0xFF004F4F) : const Color(0xFF191C1C),
                                    fontWeight: _selectedCategory == cat ? FontWeight.w600 : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Список інструментів
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return ToolCard(
                      tool: item,
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => ToolDetailScreen(tool: item),
                          ),
                        );
                        setState(() {
                          final idx = AppConstants.tools.indexWhere((t) => t.id == _selectedTool.id);
                          if (idx != -1) {
                            _selectedTool = AppConstants.tools[idx];
                          }
                        });
                      },
                    );
                  },
                ),
              ),
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
          onPressed: () async {
            final newTool = await ToolActionDialogs.showAddToolDialog(context);
            if (newTool != null) {
              setState(() {
                _selectedTool = newTool;
              });
            }
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (index) {
          if (index == _navIndex) return;
          setState(() => _navIndex = index);
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (context) => const HomeDashboardScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (context) => const StorageLocationsScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.of(context).pushReplacement(
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

  // ignore: unused_element
  Widget _buildRailItem({
    required IconData icon,
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
              icon,
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

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryTeal),
        const SizedBox(width: 10),
        Column(
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF191C1C),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
