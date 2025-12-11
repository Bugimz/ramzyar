# معماری پروژه رمزیار

## نمای کلی

رمزیار یک اپلیکیشن مدیریت رمز عبور است که با Flutter ساخته شده و از معماری GetX استفاده می‌کند.

---

## لایه‌ها

### 1. Presentation Layer (UI)

```
screens/
├── home/                   # صفحه اصلی با tab vault و generator
├── lock/                   # صفحه قفل و احراز هویت
├── password_form/          # فرم افزودن/ویرایش
└── setup_pin/              # تنظیم PIN اولیه
```

### 2. Business Logic Layer (Controllers)

| Controller            | مسئولیت                               |
| --------------------- | ------------------------------------- |
| `AuthController`      | احراز هویت، PIN، بیومتریک، قفل خودکار |
| `PasswordController`  | CRUD پسوردها، جستجو، کلیپ‌بورد        |
| `GeneratorController` | تولید رمز تصادفی                      |
| `ThemeController`     | مدیریت تم روشن/تاریک                  |

### 3. Data Layer (Services)

| Service             | مسئولیت                   |
| ------------------- | ------------------------- |
| `DbService`         | ذخیره و بازیابی از SQLite |
| `EncryptionService` | رمزنگاری AES-256-CBC      |

---

## جریان داده

```
┌─────────────┐     ┌────────────────┐     ┌───────────────┐
│   Screen    │ ──▶ │   Controller   │ ──▶ │    Service    │
└─────────────┘     └────────────────┘     └───────────────┘
       │                    │                      │
    UI Events           Rx<T>               Encrypted Data
```

---

## امنیت

### رمزنگاری

- الگوریتم: AES-256-CBC
- کلید: 256-bit تصادفی (Secure Random)
- IV: 128-bit تصادفی
- ذخیره کلید: Flutter Secure Storage

### احراز هویت

- PIN 4 رقمی
- بیومتریک (اختیاری)
- Rate Limiting: قفل 5 دقیقه‌ای بعد از 5 تلاش ناموفق

---

## GetX Bindings

```
main.dart
└── ThemeController (permanent)

InitialBinding
├── AuthController (permanent)
└── PasswordController (permanent)

Route Bindings
├── HomeBinding → HomeController, GeneratorController
├── SetupPinBinding → SetupPinController
└── PasswordFormBinding → PasswordFormController
```
