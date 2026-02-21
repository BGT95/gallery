# WebAnt Gallery

Мобильное приложение-галерея фотографий, разработанное на Flutter с использованием Clean Architecture.

## Функциональность

- Просмотр новых и популярных фотографий с пагинацией
- Pull-to-refresh для обновления списка
- Детальный просмотр фотографий с Hero-анимацией
- Регистрация и авторизация (OAuth2 с автообновлением токена)
- Offline-режим с кешированием данных (Hive)
- Баннер отсутствия интернет-соединения
- Адаптивная сетка (2 колонки portrait / 4 колонки landscape)

## Архитектура

Гибридная Clean Architecture: `core/` для общей инфраструктуры + `features/` для бизнес-логики.

```
lib/
├── core/                          # Общая инфраструктура
│   ├── di/                        # Dependency Injection (GetIt)
│   ├── domain/                    # Failures, Exceptions
│   ├── infrastructure/
│   │   ├── local/                 # HiveService
│   │   └── network/               # NetworkInfo, AuthInterceptor
│   ├── presentation/
│   │   ├── theme/                 # AppColors, AppTheme
│   │   └── widgets/               # CustomButton, AppTextField, OfflineBanner
│   └── utils/                     # ApiConstants, AppLogger
├── features/
│   ├── auth/                      # Авторизация
│   │   ├── domain/                # User entity, AuthRepository interface
│   │   ├── infrastructure/        # TokenManager, AuthRemoteDataSource
│   │   └── presentation/          # Splash, Welcome, SignIn, SignUp
│   └── gallery/                   # Галерея
│       ├── domain/                # Photo entity, GalleryRepository interface
│       ├── infrastructure/        # Remote/Local DataSources, Repository impl
│       └── presentation/          # BLoC, HomePage, PhotoList, PhotoDetail
└── gen/                           # FlutterGen (assets)
```

## Стек технологий

| Категория | Библиотека |
|---|---|
| State Management | `flutter_bloc` |
| Dependency Injection | `get_it` |
| Network | `dio` |
| Local Cache | `hive`, `hive_flutter` |
| Auth Token Storage | `shared_preferences` |
| Connectivity | `connectivity_plus` |
| Image Caching | `cached_network_image` |
| Error Handling | `dartz` (Either) |
| SVG | `flutter_svg` |
| Code Generation | `flutter_gen_runner`, `build_runner` |

## Запуск

```bash
# Установка зависимостей
flutter pub get

# Генерация ассетов
dart run build_runner build --delete-conflicting-outputs

# Запуск
flutter run
```

## API

Backend: `https://gallery.prod2.webant.ru/`

| Endpoint | Описание |
|---|---|
| `POST /token` | Авторизация (password grant) и обновление токена |
| `POST /users` | Регистрация |
| `GET /photos` | Список фотографий (new/popular, пагинация) |
| `GET /photos/{id}` | Детали фотографии |

## Экраны

| Экран | Описание |
|---|---|
| Splash | Логотип, проверка авторизации, навигация |
| Welcome | Онбординг с выбором Sign In / Sign Up |
| Sign In | Форма входа (email, password) |
| Sign Up | Форма регистрации (name, birthday, phone, email, password) |
| Home | Табы New/Popular, поиск, нижняя навигация |
| Photo List | Сетка фотографий с пагинацией |
| Photo Detail | Полноэкранный просмотр с описанием |
