import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/tool_item.dart';

/// Екран детальної інформації про інструмент (S-09, FR-10)
class ToolDetailScreen extends StatelessWidget {
  final ToolItem tool;

  const ToolDetailScreen({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Деталі інструмента'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Редагувати',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Режим редагування інструмента')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppTheme.statusRepairColor),
            tooltip: 'Видалити',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Діалог видалення інструмента')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Блок зображення / банера інструмента
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tool.category == 'Електроінструмент'
                              ? Icons.power
                              : (tool.category == 'Ручний інструмент'
                                  ? Icons.handyman
                                  : Icons.build),
                          size: 64,
                          color: AppTheme.primarySeedColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tool.category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primarySeedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Назва та бейдж статусу
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        tool.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C1C),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tool.status == ToolStatus.available
                            ? AppTheme.statusAvailableBg
                            : (tool.status == ToolStatus.loaned
                                ? AppTheme.statusLoanedBg
                                : AppTheme.statusRepairBg),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tool.statusTitle,
                        style: TextStyle(
                          color: tool.status == ToolStatus.available
                              ? AppTheme.statusAvailableColor
                              : (tool.status == ToolStatus.loaned
                                  ? AppTheme.statusLoanedColor
                                  : AppTheme.statusRepairColor),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Інформаційні блоки
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailItem(
                          icon: Icons.location_on_outlined,
                          title: 'Місце зберігання',
                          value: tool.location,
                        ),
                        const Divider(height: 20),
                        _buildDetailItem(
                          icon: Icons.health_and_safety_outlined,
                          title: 'Технічний стан',
                          value: tool.condition,
                        ),
                        if (tool.serialNumber != null) ...[
                          const Divider(height: 20),
                          _buildDetailItem(
                            icon: Icons.qr_code_2_outlined,
                            title: 'Серійний номер',
                            value: tool.serialNumber!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Опис
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Опис та характеристики',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF191C1C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tool.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3F4948),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Якщо видано - блок інформації про позику
                if (tool.status == ToolStatus.loaned && tool.loanedTo != null) ...[
                  Card(
                    color: AppTheme.statusLoanedBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppTheme.statusLoanedColor.withValues(alpha: 0.3)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline, color: AppTheme.statusLoanedColor, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Інформація про позику',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.statusLoanedColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Отримувач: ${tool.loanedTo}'),
                          Text('Дата видачі: ${tool.loanedDate ?? "—"}'),
                          Text('Очікуване повернення: ${tool.expectedReturnDate ?? "—"}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Кнопки швидкої дії
                if (tool.status == ToolStatus.available)
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Відкрито форму видачі інструмента')),
                      );
                    },
                    icon: const Icon(Icons.outbox_rounded),
                    label: const Text('Видати інструмент'),
                  )
                else if (tool.status == ToolStatus.loaned)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.statusAvailableColor,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Інструмент успішно повернено на місце!')),
                      );
                    },
                    icon: const Icon(Icons.move_to_inbox_rounded),
                    label: const Text('Підтвердити повернення'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6F7978)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6F7978)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
