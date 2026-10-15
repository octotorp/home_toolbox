import 'package:flutter/material.dart';
import '../../models/tool_item.dart';
import '../theme/app_theme.dart';

/// Віджет картки інструмента у списку або на головній панелі
class ToolCard extends StatelessWidget {
  final ToolItem tool;
  final VoidCallback? onTap;

  const ToolCard({
    super.key,
    required this.tool,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (tool.status) {
      case ToolStatus.available:
        return AppTheme.statusAvailableColor;
      case ToolStatus.loaned:
        return AppTheme.statusLoanedColor;
      case ToolStatus.inRepair:
        return AppTheme.statusRepairColor;
    }
  }

  Color _getStatusBg() {
    switch (tool.status) {
      case ToolStatus.available:
        return AppTheme.statusAvailableBg;
      case ToolStatus.loaned:
        return AppTheme.statusLoanedBg;
      case ToolStatus.inRepair:
        return AppTheme.statusRepairBg;
    }
  }

  IconData _getCategoryIcon() {
    switch (tool.category) {
      case 'Електроінструмент':
        return Icons.power;
      case 'Ручний інструмент':
        return Icons.handyman;
      case 'Вимірювальний':
        return Icons.straighten;
      case 'Садовий':
        return Icons.yard;
      default:
        return Icons.build;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  color: AppTheme.primarySeedColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            tool.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191C1C),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusBg(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tool.statusTitle,
                            style: TextStyle(
                              color: _getStatusColor(),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 15, color: Color(0xFF6F7978)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            tool.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6F7978),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (tool.status == ToolStatus.loaned && tool.loanedTo != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 15, color: AppTheme.statusLoanedColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'У: ${tool.loanedTo} (до ${tool.expectedReturnDate ?? "—"})',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.statusLoanedColor,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
