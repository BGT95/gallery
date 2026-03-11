# WebAnt Gallery

Мобильное приложение-галерея фотографий на Flutter. Clean Architecture, BLoC, декларативная навигация.

## Функциональность

- Просмотр новых и популярных фотографий с пагинацией
- Pull-to-refresh для обновления списка
- Детальный просмотр фотографий с Hero-анимацией
- Регистрация и авторизация (OAuth2 с автообновлением токена)
- Offline-режим с кешированием данных (Hive)
- Баннер отсутствия интернет-соединения в реальном времени
- Адаптивная сетка (2 колонки portrait / 4 колонки landscape)

## Архитектура

Гибридная Clean Architecture: `core/` для общей инфраструктуры + `features/` для бизнес-логики.

```
lib/
├── core/
│   ├── di/                        # Dependency Injection (GetIt)
│   ├── domain/                    # Failures, Exceptions
│   ├── infrastructure/
│   │   ├── local/                 # HiveService
│   │   └── network/               # NetworkInfo, AuthInterceptor
│   ├── presentation/
│   │   ├── router/                # GoRouter (маршруты, redirect, guards)
│   │   ├── theme/                 # AppColors, AppTheme
│   │   └── widgets/               # CustomButton, AppTextField, OfflineBanner
│   └── utils/                     # ApiConstants, AppLogger
├── features/
│   ├── auth/
│   │   ├── domain/                # User entity, AuthRepository interface
│   │   ├── infrastructure/        # TokenManager, AuthRemoteDataSource
│   │   └── presentation/
│   │       ├── bloc/              # SignInBloc, SignUpBloc
│   │       ├── screens/           # Splash, Welcome, SignIn, SignUp
│   │       └── widgets/           # GradientTitle
│   └── gallery/
│       ├── domain/                # Photo entity, GalleryRepository interface
│       ├── infrastructure/        # Remote/Local DataSources, PhotoModel, Repository impl
│       └── presentation/
│           ├── bloc/              # PhotoListBloc, PhotoDetailBloc
│           ├── screens/           # HomePage, PhotoList, PhotoDetail
│           └── widgets/           # PhotoGridItem
└── gen/                           # FlutterGen (assets)
```

## Стек технологий

| Категория | Библиотека |
|---|---|
| State Management | `flutter_bloc` |
| Navigation | `go_router` |
| Dependency Injection | `get_it` |
| Network | `dio` |
| Local Cache | `hive`, `hive_flutter` |
| Auth Token Storage | `shared_preferences` |
| Connectivity | `connectivity_plus` |
| Image Caching | `cached_network_image` |
| Functional Types | `dartz` (Either) |
| SVG | `flutter_svg` |
| Code Generation | `flutter_gen_runner`, `build_runner` |

## Запуск

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
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

| Экран | Маршрут | Описание |
|---|---|---|
| Splash | `/splash` | Брендированный логотип → redirect |
| Welcome | `/welcome` | Онбординг: Sign In / Sign Up |
| Sign In | `/sign-in` | Форма входа (BLoC) |
| Sign Up | `/sign-up` | Форма регистрации (BLoC) |
| Home | `/home` | Табы New/Popular, нижняя навигация |
| Photo List | — | Сетка фотографий с пагинацией (BLoC) |
| Photo Detail | `/photo/:id` | Полноэкранный просмотр с описанием (BLoC) |
