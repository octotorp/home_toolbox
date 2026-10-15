import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/tool_item.dart';

/// Модальні вікна та форми для виконання операцій: Видати, Повернути, Редагувати, Додати та Видалити інструмент.
class ToolActionDialogs {
  /// 1. Діалог видачі інструмента або повернення позиченого
  static Future<ToolItem?> showLoanDialog(BuildContext context, ToolItem tool) async {
    if (tool.status == ToolStatus.loaned) {
      // Якщо інструмент уже видано - пропонуємо оформити повернення
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.assignment_return_outlined, color: AppTheme.primaryTeal),
              SizedBox(width: 10),
              Text('Повернення інструмента', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Інструмент "${tool.name}" зараз перебуває у позиці: ${tool.loanedTo ?? "позичальника"}.\n\nЗафіксувати повернення інструмента на своє місце зберігання (${tool.location})?',
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Скасувати', style: TextStyle(color: Color(0xFF52605E))),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Підтвердити повернення'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        AppConstants.returnTool(tool.id);
        final updated = AppConstants.tools.firstWhere((t) => t.id == tool.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Інструмент "${tool.name}" успішно повернено до комори!'),
            backgroundColor: AppTheme.primaryTeal,
          ),
        );
        return updated;
      }
      return null;
    }

    // Якщо інструмент в наявності - відкриваємо форму видачі
    final personController = TextEditingController(text: 'Сусід Андрій');
    final daysController = TextEditingController(text: '7');
    final notesController = TextEditingController();

    final result = await showDialog<ToolItem?>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.swap_horiz_rounded, color: AppTheme.primaryTeal),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Видати: ${tool.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Вкажіть дані позичальника та термін позики:',
                  style: TextStyle(color: Color(0xFF52605E), fontSize: 14),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: personController,
                  label: 'Кому видано (імʼя позичальника)',
                  hint: 'Наприклад: Сусід Андрій, Брат Олег',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: daysController,
                  label: 'Термін позики (днів)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: notesController,
                  label: 'Телефон або примітка (необовʼязково)',
                  hint: '+380 ...',
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Скасувати', style: TextStyle(color: Color(0xFF52605E))),
          ),
          ElevatedButton(
            onPressed: () {
              final person = personController.text.trim().isEmpty ? 'Сусід' : personController.text.trim();
              final days = daysController.text.trim().isEmpty ? '7' : daysController.text.trim();
              AppConstants.loanTool(tool.id, person, days);
              final updated = AppConstants.tools.firstWhere((t) => t.id == tool.id);
              Navigator.of(ctx).pop(updated);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryTeal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Видати інструмент'),
          ),
        ],
      ),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Інструмент "${result.name}" видано: ${result.loanedTo}!'),
          backgroundColor: AppTheme.primaryTeal,
        ),
      );
    }
    return result;
  }

  /// 2. Діалог редагування параметрів інструмента
  static Future<ToolItem?> showEditToolDialog(BuildContext context, ToolItem tool) async {
    final nameController = TextEditingController(text: tool.name);
    final locationController = TextEditingController(text: tool.location);
    final notesController = TextEditingController(text: tool.notes ?? '');
    String selectedCategory = tool.category;
    String selectedCondition = tool.condition;

    final categories = ['Електроінструмент', 'Електро', 'Ручні', 'Інше'];
    if (!categories.contains(selectedCategory)) {
      categories.insert(0, selectedCategory);
    }

    final conditions = ['Відмінний', 'Добрий стан', 'Добрий', 'Ремонт'];
    if (!conditions.contains(selectedCondition)) {
      conditions.insert(0, selectedCondition);
    }

    final result = await showDialog<ToolItem?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.edit_outlined, color: AppTheme.primaryTeal),
              SizedBox(width: 10),
              Text('Редагувати інструмент', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: nameController,
                    label: 'Назва інструмента',
                  ),
                  const SizedBox(height: 14),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Категорія',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        items: categories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedCategory = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: locationController,
                    label: 'Місце зберігання',
                  ),
                  const SizedBox(height: 14),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Технічний стан',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCondition,
                        isExpanded: true,
                        items: conditions
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedCondition = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: notesController,
                    label: 'Нотатки / примітки',
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Скасувати', style: TextStyle(color: Color(0xFF52605E))),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim().isEmpty ? tool.name : nameController.text.trim();
                final newLocation = locationController.text.trim().isEmpty ? tool.location : locationController.text.trim();
                final isRepair = selectedCondition.contains('Ремонт');

                final updated = tool.copyWith(
                  name: newName,
                  category: selectedCategory,
                  location: newLocation,
                  condition: selectedCondition,
                  status: isRepair ? ToolStatus.inRepair : (tool.status == ToolStatus.inRepair ? ToolStatus.available : tool.status),
                  notes: notesController.text.trim(),
                );
                AppConstants.updateTool(updated);
                Navigator.of(ctx).pop(updated);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Зберегти зміни'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Дані інструмента "${result.name}" успішно оновлено!'),
          backgroundColor: AppTheme.primaryTeal,
        ),
      );
    }
    return result;
  }

  /// 3. Діалог швидкої зміни стану (для мобільного екрана)
  static Future<ToolItem?> showChangeConditionDialog(BuildContext context, ToolItem tool) async {
    final conditions = ['Відмінний', 'Добрий стан', 'Потребує ремонту'];
    String chosen = tool.condition;

    final result = await showDialog<ToolItem?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Змінити стан інструмента', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: conditions.map((cond) {
              return RadioListTile<String>(
                title: Text(cond),
                value: cond,
                groupValue: chosen,
                activeColor: AppTheme.primaryTeal,
                onChanged: (val) {
                  if (val != null) setState(() => chosen = val);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Скасувати', style: TextStyle(color: Color(0xFF52605E))),
            ),
            ElevatedButton(
              onPressed: () {
                final isRepair = chosen.contains('ремонт');
                final updated = tool.copyWith(
                  condition: chosen,
                  status: isRepair ? ToolStatus.inRepair : (tool.status == ToolStatus.inRepair ? ToolStatus.available : tool.status),
                );
                AppConstants.updateTool(updated);
                Navigator.of(ctx).pop(updated);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Застосувати'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Стан оновлено: ${result.condition}'),
          backgroundColor: AppTheme.primaryTeal,
        ),
      );
    }
    return result;
  }

  /// 4. Діалог додавання нового інструмента
  static Future<ToolItem?> showAddToolDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final locationController = TextEditingController(text: 'Гараж · стелаж А');
    final notesController = TextEditingController();
    String selectedCategory = 'Електроінструмент';
    String selectedCondition = 'Відмінний';

    final categories = ['Електроінструмент', 'Електро', 'Ручні', 'Інше'];
    final conditions = ['Відмінний', 'Добрий стан', 'Добрий', 'Ремонт'];

    final result = await showDialog<ToolItem?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.add_circle_outline, color: AppTheme.primaryTeal),
              SizedBox(width: 10),
              Text('Новий інструмент', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: nameController,
                    label: 'Назва інструмента',
                    hint: 'Наприклад: Перфоратор Makita HR2470',
                  ),
                  const SizedBox(height: 14),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Категорія',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        items: categories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedCategory = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: locationController,
                    label: 'Місце зберігання',
                    hint: 'Гараж, Комора, тощо',
                  ),
                  const SizedBox(height: 14),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Технічний стан',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCondition,
                        isExpanded: true,
                        items: conditions
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedCondition = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: notesController,
                    label: 'Нотатки (необовʼязково)',
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Скасувати', style: TextStyle(color: Color(0xFF52605E))),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final newTool = ToolItem(
                  id: 'tool_${DateTime.now().millisecondsSinceEpoch}',
                  name: name,
                  category: selectedCategory,
                  location: locationController.text.trim().isEmpty ? 'Гараж' : locationController.text.trim(),
                  condition: selectedCondition,
                  status: selectedCondition.contains('Ремонт') ? ToolStatus.inRepair : ToolStatus.available,
                  description: 'Користувацький інструмент доданий до домашньої комори.',
                  purchaseDate: 'сьогодні',
                  notes: notesController.text.trim(),
                );
                AppConstants.addTool(newTool);
                Navigator.of(ctx).pop(newTool);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Додати інструмент'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Інструмент "${result.name}" успішно додано до каталогу!'),
          backgroundColor: AppTheme.primaryTeal,
        ),
      );
    }
    return result;
  }

  /// 5. Діалог видалення інструмента
  static Future<bool> showDeleteDialog(BuildContext context, ToolItem tool) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Color(0xFFA82222)),
            SizedBox(width: 10),
            Text('Видалити інструмент?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Ви дійсно бажаєте безповоротно видалити "${tool.name}" з каталогу?',
          style: const TextStyle(fontSize: 15),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Скасувати', style: TextStyle(color: Color(0xFF52605E))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA82222),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      AppConstants.deleteTool(tool.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Інструмент "${tool.name}" видалено.'),
          backgroundColor: const Color(0xFFA82222),
        ),
      );
      return true;
    }
    return false;
  }
}
