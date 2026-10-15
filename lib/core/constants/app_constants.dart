import '../../models/user_profile.dart';
import '../../models/tool_item.dart';

/// Статичні константи та mock-дані відповідно до вимог Лабораторної роботи №3
class AppConstants {
  // Mock-дані авторизованого користувача
  static const UserProfile currentUser = UserProfile(
    id: 'user_001',
    firstName: 'Владислав',
    lastName: 'Прокопів',
    email: 'vlad.prokopiv@lpnu.ua',
    phone: '+380 (67) 123-45-67',
  );

  // Категорії інструментів
  static const List<String> categories = [
    'Усі',
    'Електроінструмент',
    'Ручний інструмент',
    'Вимірювальний',
    'Садовий',
  ];

  // Місця зберігання
  static const List<String> storageLocations = [
    'Гараж, стелаж А1',
    'Майстерня, полиця 2',
    'Балкон, тумба B',
    'Комора, ящик №3',
  ];

  // Початковий список домашніх інструментів
  static const List<ToolItem> mockTools = [
    ToolItem(
      id: 'tool_1',
      name: 'Перфоратор Bosch GBH 2-26 DRE',
      category: 'Електроінструмент',
      location: 'Гараж, стелаж А1',
      condition: 'Відмінний',
      status: ToolStatus.available,
      description: 'Потужний перфоратор 800 Вт, удар 2.7 Дж, патрон SDS-Plus. Повний комплект з бурами.',
      serialNumber: 'BSH-982314-UA',
    ),
    ToolItem(
      id: 'tool_2',
      name: 'Акумуляторний шуруповерт DeWalt DCD791',
      category: 'Електроінструмент',
      location: 'Майстерня, полиця 2',
      condition: 'Відмінний',
      status: ToolStatus.loaned,
      loanedTo: 'Тарас Шевченко (сусід)',
      loanedDate: '10.10.2026',
      expectedReturnDate: '18.10.2026',
      description: 'Безщітковий шуруповерт 18V XR Li-Ion, 2 швидкості, крутний момент 70 Нм, 2 акумулятори 5.0Ah.',
      serialNumber: 'DW-441209-X',
    ),
    ToolItem(
      id: 'tool_3',
      name: 'Кутова шліфмашина Makita GA5030',
      category: 'Електроінструмент',
      location: 'Гараж, стелаж А1',
      condition: 'Задовільний',
      status: ToolStatus.inRepair,
      description: 'Болгарка 125 мм, 720 Вт. Потребує заміни графітових щіток та огляду кнопки пуску.',
      serialNumber: 'MKT-110293-K',
    ),
    ToolItem(
      id: 'tool_4',
      name: 'Набір комбінованих ключів Stanley 12 шт',
      category: 'Ручний інструмент',
      location: 'Комора, ящик №3',
      condition: 'Відмінний',
      status: ToolStatus.available,
      description: 'Ключі комбіновані хром-ванадій розміром 6-19 мм в зручному чохлі-скрутці.',
      serialNumber: 'ST-552190',
    ),
    ToolItem(
      id: 'tool_5',
      name: 'Лазерний нівелір Huepar 3D 360°',
      category: 'Вимірювальний',
      location: 'Майстерня, полиця 2',
      condition: 'Відмінний',
      status: ToolStatus.loaned,
      loanedTo: 'Олег Мельник (брат)',
      loanedDate: '12.10.2026',
      expectedReturnDate: '20.10.2026',
      description: 'Самовирівнювальний зелений лазерний рівень на 12 ліній. З магнітним кронштейном.',
      serialNumber: 'HP-993821',
    ),
    ToolItem(
      id: 'tool_6',
      name: 'Електролобзик DeWalt DW349',
      category: 'Електроінструмент',
      location: 'Балкон, тумба B',
      condition: 'Добрий',
      status: ToolStatus.available,
      description: 'Лобзик 500 Вт з регулюванням обертів та маятниковим ходом.',
      serialNumber: 'DW-782104-E',
    ),
  ];
}
