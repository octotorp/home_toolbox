import 'package:flutter/material.dart';
import '../../models/tool_item.dart';
import '../theme/app_theme.dart';

/// Віджет картки інструмента у списку або на адаптивній панелі
class ToolCard extends StatelessWidget {
  final ToolItem tool;
  final bool isSelected;
  final VoidCallback? onTap;

  const ToolCard({
    super.key,
    required this.tool,
    this.isSelected = false,
    this.onTap,
  });

  String get _badgeText {
    if (tool.status == ToolStatus.loaned) return 'Видано';
    if (tool.status == ToolStatus.inRepair) return 'Ремонт';
    if (tool.condition.contains('Відмін')) return 'Відмінний';
    return 'Добрий';
  }

  Color get _badgeBg {
    if (tool.status == ToolStatus.loaned) return AppTheme.statusLoanedBg;
    if (tool.status == ToolStatus.inRepair) return AppTheme.statusRepairBg;
    if (tool.condition.contains('Відмін')) return AppTheme.statusAvailableBg;
    return AppTheme.badgeGoodBg;
  }

  Color get _badgeTextColor {
    if (tool.status == ToolStatus.loaned) return AppTheme.statusLoanedColor;
    if (tool.status == ToolStatus.inRepair) return AppTheme.statusRepairColor;
    if (tool.condition.contains('Відмін')) return AppTheme.statusAvailableColor;
    return AppTheme.badgeGoodText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE0EDEB) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Іконка інструмента
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

              // Назва та локація
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tool.location,
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

              // Бейдж статусу / стану
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _badgeText,
                  style: TextStyle(
                    color: _badgeTextColor,
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
