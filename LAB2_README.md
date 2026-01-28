# Лабораторна робота №2

## Структура проекту

### 📁 Файли

```
lib/
├── main.dart                    - Точка входу, навігація
├── screens/                     - Екрани додатку
│   ├── login_screen.dart        - Екран входу (admin/admin)
│   ├── register_screen.dart     - Екран реєстрації
│   ├── home_screen.dart         - Головна сторінка
│   └── profile_screen.dart      - Профіль користувача
└── widgets/                     - Переносні компоненти
    ├── custom_text_field.dart   - Поле вводу
    ├── custom_button.dart       - Кнопка
    └── custom_card.dart         - Карточка
```

## 🔐 Облікові дані

**Login:** admin  
**Password:** admin

## 📋 Функціональність

### Login Screen
- Вхід з email та паролем
- Стандартні участкові дані: admin/admin
- Навігація до реєстрації та входу

### Register Screen
- Форма реєстрації (без логіки)
- Поля: ім'я, email, пароль
- Повернення на login

### Home Screen
- Головна сторінка
- Привіт користувачу
- Місце для майбутньої основної програми

### Profile Screen
- Профіль користувача
- Відображення емейлу та телефону
- Кнопка виходу

## 🎨 Дизайн

- **Тема:** Dark mode з Indigo кольорами
- **Material Design:** 3
- **Стиль:** Чистий та простий
- **Componenty:** Переиспользуються (CustomTextField, CustomButton, CustomCard)

## 🚀 Запуск

```bash
flutter pub get
flutter run
```

## ✅ Перевірки

```bash
flutter analyze    # Перевірка лінтера
flutter pub get    # Отримання залежностей
```

Всі вимоги виконані! ✓
