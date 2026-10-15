import '../../models/user_profile.dart';
import '../../models/tool_item.dart';

/// Статичні константи та mock-дані відповідно до вимог Лабораторної роботи №3 та макетів Лаб №2
class AppConstants {
  // Mock-дані авторизованого користувача
  static const UserProfile currentUser = UserProfile(
    id: 'user_001',
    firstName: 'Влад',
    lastName: 'Прокопів',
    email: 'vlad@example.com',
    phone: '+380 (67) 123-45-67',
  );

  // Категорії інструментів згідно макетів (image6.png, image12.png)
  static const List<String> categories = [
    'Усі',
    'Електро',
    'Ручні',
    'Інше',
  ];

  // Місця зберігання
  static const List<String> storageLocations = [
    'Гараж · стелаж А, полиця 2',
    'Гараж · стелаж Б',
    'Комора · ящик 1',
    'Комора · ящик 2',
    'Балкон',
  ];

  // Список домашніх інструментів, що повністю відповідає макетам Лабораторної роботи №2
  static const List<ToolItem> mockTools = [
    ToolItem(
      id: 'tool_1',
      name: 'Дриль ударний Bosch GSB 13 RE',
      category: 'Електроінструмент',
      location: 'Гараж · стелаж А, полиця 2',
      condition: 'Добрий стан',
      status: ToolStatus.available,
      purchaseDate: '14.03.2023',
      notes: 'Комплект свердел у кейсі',
      serialNumber: 'SN-8849201',
      description: 'Потужний ударний дриль Bosch GSB 13 RE (600 Вт). Оснащений реверсом, електронним регулюванням швидкості та надійним ключовим патроном 13 мм.',
    ),
    ToolItem(
      id: 'tool_2',
      name: 'Шуруповерт Makita',
      category: 'Електро',
      location: 'Гараж · стелаж А',
      condition: 'Відмінний',
      status: ToolStatus.loaned,
      loanedTo: 'Сусід Андрій',
      loanedDate: 'з 22.09',
      expectedReturnDate: '7 днів',
      description: 'Акумуляторний ударний дриль-шуруповерт 18V LXT із двома акумуляторами та зарядним пристроєм у міцному кейсі.',
      serialNumber: 'MKT-441209',
    ),
    ToolItem(
      id: 'tool_3',
      name: 'Молоток слюсарний',
      category: 'Ручні',
      location: 'Комора · ящик 1',
      condition: 'Добрий',
      status: ToolStatus.available,
      description: 'Слюсарний молоток 500 грамів з кованої сталі з ергономічною двокомпонентною ручкою з фібергласу.',
      serialNumber: 'HAM-500',
    ),
    ToolItem(
      id: 'tool_4',
      name: 'Рівень 60 см',
      category: 'Ручні',
      location: 'Комора · ящик 2',
      condition: 'Відмінний',
      status: ToolStatus.available,
      description: 'Будівельний алюмінієвий рівень завдовжки 60 см з 3 ударостійкими ампулами та фрезерованою магнітною базою.',
      serialNumber: 'LVL-600',
    ),
    ToolItem(
      id: 'tool_5',
      name: 'Болгарка 125 мм',
      category: 'Електро',
      location: 'Гараж · стелаж Б',
      condition: 'Ремонт',
      status: ToolStatus.inRepair,
      description: 'Кутова шліфувальна машина 125 мм, потужність 850 Вт. Наразі потребує заміни графітових щіток та профілактики редуктора.',
      serialNumber: 'AG-125-85',
    ),
    ToolItem(
      id: 'tool_6',
      name: 'Драбина алюмінієва',
      category: 'Інше',
      location: 'Балкон',
      condition: 'Відмінний',
      status: ToolStatus.loaned,
      loanedTo: 'Брат Олег',
      loanedDate: 'з 28.08',
      expectedReturnDate: '32 дні',
      description: 'Універсальна трисекційна розкладна драбина 3х7 сходинок, робоча висота до 4.5 м, максимальне навантаження 150 кг.',
      serialNumber: 'LAD-3X7',
    ),
  ];
}
