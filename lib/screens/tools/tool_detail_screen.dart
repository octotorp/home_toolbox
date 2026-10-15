import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/tool_item.dart';
import 'tool_action_dialogs.dart';

/// Екран детальної інформації про інструмент (S-09, FR-10, image7.png)
class ToolDetailScreen extends StatefulWidget {
  final ToolItem tool;

  const ToolDetailScreen({super.key, required this.tool});

  @override
  State<ToolDetailScreen> createState() => _ToolDetailScreenState();
}

class _ToolDetailScreenState extends State<ToolDetailScreen> {
  late ToolItem _tool;

  @override
  void initState() {
    super.initState();
    // Підтягуємо актуальні дані з репозиторію, якщо є
    final match = AppConstants.tools.firstWhere(
      (t) => t.id == widget.tool.id,
      orElse: () => widget.tool,
    );
    _tool = match;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(_tool),
        ),
        title: Text(
          _tool.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Редагувати',
            onPressed: () async {
              final updated = await ToolActionDialogs.showEditToolDialog(context, _tool);
              if (updated != null) {
                setState(() => _tool = updated);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Видалити',
            onPressed: () async {
              final deleted = await ToolActionDialogs.showDeleteDialog(context, _tool);
              if (deleted && mounted) {
                Navigator.of(context).pop(null);
              }
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
                        _tool.name,
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
                              _tool.condition,
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
                              color: _tool.status == ToolStatus.available
                                  ? AppTheme.statusAvailableBg
                                  : (_tool.status == ToolStatus.loaned
                                      ? AppTheme.statusLoanedBg
                                      : AppTheme.statusRepairBg),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _tool.statusTitle,
                              style: TextStyle(
                                color: _tool.status == ToolStatus.available
                                    ? AppTheme.statusAvailableColor
                                    : (_tool.status == ToolStatus.loaned
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
                        value: _tool.category,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Придбано',
                        value: _tool.purchaseDate ?? '14.03.2023',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Місце зберігання',
                        value: _tool.location,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.edit_note_outlined,
                        label: 'Нотатки',
                        value: _tool.notes ?? 'Комплект свердел у кейсі',
                      ),
                      if (_tool.status == ToolStatus.loaned && _tool.loanedTo != null) ...[
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          label: 'Видано позичальнику',
                          value: '${_tool.loanedTo} (${_tool.expectedReturnDate ?? "термін не вказано"})',
                        ),
                      ],
                      const SizedBox(height: 28),

                      // Кнопки дій: Видати / Повернути та Змінити стан
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final updated = await ToolActionDialogs.showLoanDialog(context, _tool);
                                if (updated != null) {
                                  setState(() => _tool = updated);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryTeal,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              icon: Icon(_tool.status == ToolStatus.loaned
                                  ? Icons.assignment_return_outlined
                                  : Icons.swap_horiz_rounded),
                              label: Text(
                                _tool.status == ToolStatus.loaned ? 'Повернути' : 'Видати',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final updated = await ToolActionDialogs.showChangeConditionDialog(context, _tool);
                                if (updated != null) {
                                  setState(() => _tool = updated);
                                }
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
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Запис історії
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F7F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFFCCDEDA),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.swap_horiz_rounded,
                                color: AppTheme.primaryTeal,
                                size: 22,
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
        Icon(icon, color: AppTheme.primaryTeal, size: 22),
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
                  fontWeight: FontWeight.w600,
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
