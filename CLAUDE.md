# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Fyllens is a Flutter mobile application for plant nutrient deficiency identification using machine learning. The app uses Supabase as the backend for authentication, database, and storage, and integrates a CNN model for deficiency detection.

**Tech Stack:** Flutter 3.35.7, Dart 3.9.2, Supabase, Provider, GoRouter, GetIt + Injectable

## Development Commands

### Setup and Dependencies
```bash
cd Fyllens
flutter pub get
# Generate dependency injection code (required after modifying @injectable classes)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Environment Setup
```bash
# Copy .env.example to .env and fill in your Supabase credentials
cp .env.example .env
```

### Running the Application
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format lib/

# Check formatting without modifying
dart format --output=none --set-exit-if-changed lib/
```

### Building
```bash
# Build APK (Android)
flutter build apk

# Build App Bundle (Android)
flutter build appbundle

# Build iOS (requires macOS)
flutter build ios

# Build for web
flutter build web
```

## Architecture

### Project Structure

```
lib/
├── main.dart                          # App entry point with Provider setup
├── app.dart                           # MaterialApp configuration with routing
├── core/
│   ├── di/
│   │   ├── injection.dart            # DI setup (GetIt + Injectable)
│   │   ├── injection.config.dart     # GENERATED - don't edit manually
│   │   └── register_module.dart      # Dependency modules
│   ├── theme/
│   │   ├── app_colors.dart           # Centralized color palette (WCAG compliant)
│   │   ├── app_text_styles.dart      # Typography system
│   │   └── app_theme.dart            # Light & dark ThemeData
│   ├── constants/
│   │   ├── app_constants.dart        # String constants
│   │   ├── app_spacing.dart          # Spacing values
│   │   └── app_routes.dart           # Route names
│   ├── config/
│   │   └── supabase_config.dart      # Supabase configuration
│   └── utils/
│       ├── validators.dart           # Form validators
│       └── extensions.dart           # Dart extensions
├── data/
│   ├── models/                        # Legacy data models (being phased out)
│   └── services/
│       ├── supabase_service.dart     # Supabase client singleton
│       ├── auth_service.dart         # Authentication operations
│       ├── database_service.dart     # CRUD operations
│       ├── storage_service.dart      # File storage
│       ├── ml_service.dart           # ML model integration
│       └── local_storage_service.dart # SharedPreferences wrapper
├── features/                          # Feature modules (Clean Architecture)
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       └── providers/
│   ├── profile/
│   │   └── presentation/providers/
│   └── scan/
│       └── presentation/providers/
├── providers/
│   └── theme_provider.dart           # Theme state (non-feature)
└── presentation/
    ├── shared/
    │   ├── widgets/                   # Reusable UI components
    │   └── layouts/
    └── pages/                         # Page UI implementations
```

### Architecture Patterns

**1. Clean Architecture (Feature Modules)**
- Each feature in `features/` follows Clean Architecture with data/domain/presentation layers
- **Domain Layer:** Entities, repository abstractions, use cases (framework-independent)
- **Data Layer:** Repository implementations, models (DTOs), data sources
- **Presentation Layer:** Providers (state management), pages

**2. State Management:** Provider pattern
- All providers extend `ChangeNotifier`
- Providers registered in `main.dart` using `MultiProvider`
- Access providers using `context.watch<T>()` for reactive widgets, `context.read<T>()` for one-time access
- Feature providers decorated with `@injectable` for DI

**3. Dependency Injection:** GetIt + Injectable
- Service locator pattern via GetIt (`sl<T>()`)
- Code generation with `@injectable` decorator
- **Important:** Run `flutter pub run build_runner build` after modifying @injectable classes
- Generated config in `lib/core/di/injection.config.dart` (don't edit manually)

**4. Navigation:** GoRouter
- Centralized routes in `core/constants/app_routes.dart`
- Router configuration in `app.dart`
- Navigate using `context.go(AppRoutes.routeName)`
- Initial route: `/` (splash) → `/onboarding` → auth → `/home` (main with 5 tabs)

**5. Theme System:**
- Colors centralized in `app_colors.dart` (WCAG AA compliant)
- Primary color scheme: Green (#2E7D32, #43A047, #1B5E20)
- Text styles in `app_text_styles.dart`
- Light and dark themes in `app_theme.dart`
- Theme switching via `ThemeProvider`

### Adding New Features

**Adding a feature module (Clean Architecture):**
1. Create folder in `lib/features/<feature_name>/`
2. Add data/, domain/, presentation/ subdirectories
3. Create entities in domain/entities/
4. Define repository interface in domain/repositories/
5. Implement repository in data/repositories/
6. Create use cases in domain/usecases/
7. Create provider in presentation/providers/ with `@injectable`
8. Run `flutter pub run build_runner build`

**Adding a new page:**
- Create page file in `lib/presentation/pages/<feature>/`
- Add route constant in `app_routes.dart`
- Register route in `app.dart`

**Creating reusable widgets:**
- Place in `lib/presentation/shared/widgets/`
- Use theme values from `app_colors.dart` and `app_text_styles.dart`
- Make widgets configurable via constructor parameters

### Supabase Setup

**Required Tables:**
```sql
-- User profiles
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users,
  email TEXT NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ
);

-- Plants
CREATE TABLE plants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  species TEXT NOT NULL,
  description TEXT NOT NULL,
  image_url TEXT,
  common_deficiencies TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Scan results
CREATE TABLE scan_results (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id),
  plant_id UUID REFERENCES plants(id),
  plant_name TEXT NOT NULL,
  image_url TEXT NOT NULL,
  deficiency_detected TEXT,
  confidence DECIMAL,
  recommendations TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Deficiencies
CREATE TABLE deficiencies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  symptoms TEXT[] NOT NULL,
  treatment TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Storage Buckets:**
- `avatars`: User profile pictures
- `scan-images`: Scanned plant images

### Important Notes

- **Never hardcode colors:** Use values from `app_colors.dart`
- **Never hardcode strings:** Use constants from `app_constants.dart`
- **Never hardcode spacing:** Use values from `app_spacing.dart`
- **Provider usage:** Always call `notifyListeners()` after state changes
- **Supabase initialization:** Happens in `main.dart`, wrapped in try-catch
- **Navigation:** Use named routes from `AppRoutes` instead of hardcoded strings

### Dependencies

Key packages:
- `supabase_flutter`: Backend integration
- `provider`: State management
- `go_router`: Navigation
- `get_it` + `injectable`: Dependency injection
- `image_picker`: Camera/gallery access
- `shared_preferences`: Local storage
- `flutter_dotenv`: Environment variables
- `cached_network_image`: Image caching

Development packages:
- `build_runner`: Code generation
- `injectable_generator`: DI code generation

### Environment Variables

Required in `.env`:
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Your Supabase anonymous key

See `.env.example` for template.
