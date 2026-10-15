import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/tool_card.dart';
import '../../models/tool_item.dart';
import 'tool_detail_screen.dart';

/// Екран списку / каталогу інструментів (S-07, FR-09)
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ToolItem> get _filteredTools {
    return AppConstants.mockTools.where((tool) {
      if (widget.initialFilterStatus != null && tool.status != widget.initialFilterStatus) {
        return false;
      }
      if (_selectedCategory != 'Усі' && tool.category != _selectedCategory) {
        return false;
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
    final filtered = _filteredTools;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог інструментів'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              // Пошуковий рядок
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Пошук за назвою або локацією...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                ),
              ),

              // Фільтр категорій
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: AppConstants.categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              // Список інструментів
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 48, color: Color(0xFF6F7978)),
                            const SizedBox(height: 12),
                            Text(
                              'Інструментів не знайдено',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final tool = filtered[index];
                          return ToolCard(
                            tool: tool,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) => ToolDetailScreen(tool: tool),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Форма додавання нового інструмента')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
