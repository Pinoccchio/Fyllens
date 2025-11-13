# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Fyllens is a Flutter mobile application for plant nutrient deficiency identification using machine learning. The app uses Supabase as the backend for authentication, database, and storage, and integrates a CNN model for deficiency detection.

## Development Commands

### Setup and Dependencies
```bash
cd Fyllens
flutter pub get
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
│   ├── theme/
│   │   ├── app_colors.dart           # Centralized color palette
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
│   ├── models/
│   │   ├── user_profile_model.dart
│   │   ├── plant_model.dart
│   │   ├── scan_result_model.dart
│   │   └── deficiency_model.dart
│   ├── services/
│   │   ├── supabase_service.dart     # Supabase client singleton
│   │   ├── auth_service.dart         # Authentication operations
│   │   ├── database_service.dart     # CRUD operations
│   │   ├── storage_service.dart      # File storage
│   │   ├── ml_service.dart           # ML model integration
│   │   └── local_storage_service.dart # SharedPreferences wrapper
│   └── repositories/
│       ├── auth_repository.dart      # Auth business logic
│       ├── scan_repository.dart      # Scan operations
│       ├── plant_repository.dart     # Plant data management
│       └── profile_repository.dart   # User profile operations
├── providers/
│   ├── auth_provider.dart            # Auth state management
│   ├── theme_provider.dart           # Theme toggle
│   ├── scan_provider.dart            # Scanning state
│   ├── history_provider.dart         # Scan history
│   └── profile_provider.dart         # User profile
└── presentation/
    ├── shared/
    │   ├── widgets/
    │   │   ├── custom_button.dart
    │   │   ├── custom_textfield.dart
    │   │   ├── loading_indicator.dart
    │   │   ├── plant_card.dart
    │   │   └── scan_result_card.dart
    │   └── layouts/
    │       └── main_layout.dart
    └── pages/
        ├── splash/
        ├── onboarding/
        ├── auth/
        │   ├── login_page.dart
        │   ├── register_page.dart
        │   └── forgot_password_page.dart
        ├── home/
        ├── library/
        ├── scan/
        ├── history/
        └── profile/
```

### Architecture Patterns

**1. State Management:** Provider pattern
- All providers extend `ChangeNotifier`
- Providers registered in `main.dart` using `MultiProvider`
- Access providers using `Provider.of<T>(context)` or `context.watch<T>()`

**2. Data Layer:**
- **Models:** Plain Dart classes with `fromJson`/`toJson` methods
- **Services:** Low-level operations (API calls, database queries)
- **Repositories:** Business logic layer that uses services

**3. Navigation:** GoRouter
- Centralized routes in `core/constants/app_routes.dart`
- Router configuration in `app.dart`
- Navigate using `context.go(AppRoutes.routeName)`

**4. Theme System:**
- Colors centralized in `app_colors.dart`
- Text styles in `app_text_styles.dart`
- Light and dark themes in `app_theme.dart`
- Theme switching via `ThemeProvider`

### UI Theme

The app uses a consistent green color scheme representing eco-friendliness:
- **Primary Color:** `Color(0xFF388E3C)` (green[700])
- **Dark Variant:** `Colors.green.shade900`
- **Background:** White (light mode), `#121212` (dark mode)
- **Icon:** `Icons.energy_savings_leaf`

### Current Implementation Status

**Completed:**
- Project structure and architecture setup
- Theme system with light/dark mode support
- Provider-based state management
- Navigation routing with GoRouter
- Supabase integration setup
- Login page UI (existing implementation preserved)
- Reusable widget components
- All data models with JSON serialization

**Pending Implementation:**
- Supabase database tables creation
- Actual authentication logic integration
- ML model integration for deficiency detection
- Image upload and scanning workflow
- Registration and password reset flows
- All main app pages (home, library, scan, history, profile)
- Bottom navigation integration

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

### Adding New Features

**1. Adding a new page:**
- Create page file in `lib/presentation/pages/<feature>/`
- Add route constant in `app_routes.dart`
- Register route in `app.dart`

**2. Adding a new model:**
- Create model in `lib/data/models/`
- Implement `fromJson` and `toJson` methods
- Add to repository if needed

**3. Adding a new service:**
- Create service in `lib/data/services/`
- Inject dependencies (Supabase, other services)
- Keep methods focused and single-purpose

**4. Creating reusable widgets:**
- Place in `lib/presentation/shared/widgets/`
- Use theme values from `app_colors.dart` and `app_text_styles.dart`
- Make widgets configurable via constructor parameters

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
- `image_picker`: Camera/gallery access
- `shared_preferences`: Local storage
- `flutter_dotenv`: Environment variables
- `cached_network_image`: Image caching
- `intl`: Date formatting

### Environment Variables

Required in `.env`:
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Your Supabase anonymous key

See `.env.example` for template.
