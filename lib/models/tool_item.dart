enum ToolStatus {
  available, // В наявності
  loaned,    // Видано / позичено
  inRepair,  // В ремонті
}

/// Модель інструмента у каталозі
class ToolItem {
  final String id;
  final String name;
  final String category;
  final String location;
  final String condition; // Відмінний, Добрий, Задовільний
  final ToolStatus status;
  final String? loanedTo;
  final String? loanedDate;
  final String? expectedReturnDate;
  final String description;
  final String? serialNumber;

  const ToolItem({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.condition,
    required this.status,
    this.loanedTo,
    this.loanedDate,
    this.expectedReturnDate,
    required this.description,
    this.serialNumber,
  });

  String get statusTitle {
    switch (status) {
      case ToolStatus.available:
        return 'В наявності';
      case ToolStatus.loaned:
        return 'Видано';
      case ToolStatus.inRepair:
        return 'В ремонті';
    }
  }
}
