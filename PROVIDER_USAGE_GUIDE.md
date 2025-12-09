# Provider Usage Guide

This guide explains how to use the simplified Provider pattern in the Fyllens app.

## Architecture Overview

The app uses a **simplified 2-layer architecture**:

```
UI (Pages/Widgets) → Provider → Service → Supabase/Storage
```

**No more:**
- ❌ Clean Architecture layers (features/, domain/, data/repositories/)
- ❌ Use cases
- ❌ GetIt/Injectable dependency injection
- ❌ Code generation (build_runner)

**Now using:**
- ✅ Direct Provider → Service communication
- ✅ Simple Service Locator pattern (`services` global object)
- ✅ Provider package for state management
- ✅ Beginner-friendly, minimal boilerplate

---

## Service Locator

All services are accessed through a global `services` object defined in `lib/services/service_locator.dart`:

```dart
final services = ServiceLocator();

// Usage in providers:
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final DatabaseService _databaseService;

  AuthProvider(this._authService, this._databaseService);
}
```

**Available Services:**
- `services.auth` - Authentication operations
- `services.database` - Database CRUD operations
- `services.storage` - File upload/download
- `services.ml` - Machine learning inference
- `services.localStorage` - Local key-value storage
- `services.supabase` - Direct Supabase client access

---

## Provider Registration

Providers are registered in `lib/main.dart` using `MultiProvider`:

```dart
runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(services.localStorage)..initialize(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(services.auth, services.database)..initialize(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileProvider(services.database, services.storage),
      ),
      ChangeNotifierProvider(
        create: (_) => ScanProvider(services.database, services.storage, services.ml),
      ),
      ChangeNotifierProvider(
        create: (_) => HistoryProvider(services.database),
      ),
    ],
    child: const MyApp(),
  ),
);
```

**Key Points:**
- Providers are created once at app startup
- Services are injected via constructor
- `..initialize()` calls any async initialization logic
- All providers extend `ChangeNotifier`

---

## Using Providers in UI

### 1. Reading Provider State (Reactive)

Use `context.watch<T>()` when you want the widget to **rebuild** when the provider's state changes:

```dart
@override
Widget build(BuildContext context) {
  final authProvider = context.watch<AuthProvider>();

  return Text('User: ${authProvider.currentUser?.email ?? "Not logged in"}');
}
```

**When to use:**
- Displaying data that can change (user info, loading states, lists)
- UI needs to update when provider calls `notifyListeners()`

### 2. Calling Provider Methods (One-time)

Use `context.read<T>()` when you want to **call a method** without rebuilding:

```dart
void _handleLogin() async {
  final authProvider = context.read<AuthProvider>();

  final success = await authProvider.signIn(
    email: _emailController.text.trim(),
    password: _passwordController.text,
  );

  if (success) {
    context.go(AppRoutes.home);
  }
}
```

**When to use:**
- Button onPressed callbacks
- Event handlers
- One-time actions (login, logout, save, delete)

### 3. Watching Specific Properties

Use `context.select<T, R>()` to rebuild only when a specific property changes:

```dart
@override
Widget build(BuildContext context) {
  final isLoading = context.select<AuthProvider, bool>((p) => p.isLoading);

  return isLoading ? CircularProgressIndicator() : LoginButton();
}
```

**When to use:**
- Optimize performance by rebuilding only when specific values change
- Avoid unnecessary rebuilds from unrelated state changes

---

## Available Providers

### 1. AuthProvider

**Location:** `lib/providers/auth_provider.dart`

**Purpose:** Manages authentication state and user session

**Key Methods:**
```dart
// Sign in with email/password
Future<bool> signIn({required String email, required String password})

// Sign up new user
Future<bool> signUp({required String email, required String password, String? displayName})

// Sign out current user
Future<void> signOut()

// Initialize auth state listener
Future<void> initialize()
```

**State:**
```dart
User? currentUser           // Currently logged in user
bool isLoading              // Loading indicator
String? errorMessage        // Error message from last operation
bool get isAuthenticated    // Whether user is logged in
```

**Usage Example:**
```dart
// In StatefulWidget
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      context.go(AppRoutes.login);
    }
  });
}

// In build method
final authProvider = context.watch<AuthProvider>();

if (authProvider.isLoading) {
  return CircularProgressIndicator();
}

ElevatedButton(
  onPressed: () async {
    final success = await context.read<AuthProvider>().signIn(
      email: email,
      password: password,
    );
    if (success) {
      context.go(AppRoutes.home);
    }
  },
  child: Text('Sign In'),
);
```

---

### 2. ProfileProvider

**Location:** `lib/providers/profile_provider.dart`

**Purpose:** Manages user profile data and avatar

**Key Methods:**
```dart
// Load user profile from database
Future<void> loadProfile(String userId)

// Create new profile
Future<bool> createProfile({required String userId, required String email, String? displayName})

// Update profile information
Future<bool> updateProfile({required String userId, String? displayName, String? avatarUrl})

// Upload profile picture
Future<bool> uploadProfilePicture({required String userId, required File imageFile})

// Clear profile state (on logout)
void clearProfile()
```

**State:**
```dart
User? userProfile       // User profile data
bool isLoading         // Loading indicator
String? errorMessage   // Error message
bool get hasProfile    // Whether profile is loaded
```

**Usage Example:**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    if (authProvider.currentUser != null) {
      profileProvider.loadProfile(authProvider.currentUser!.id);
    }
  });
}

// Display profile
final profileProvider = context.watch<ProfileProvider>();
final user = profileProvider.userProfile;

if (profileProvider.isLoading) {
  return CircularProgressIndicator();
}

Text(user?.displayName ?? 'No name');
Text(user?.email ?? 'No email');

// Update profile
ElevatedButton(
  onPressed: () async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    await profileProvider.updateProfile(
      userId: authProvider.currentUser!.id,
      displayName: newName,
    );
  },
  child: Text('Save'),
);
```

---

### 3. HistoryProvider

**Location:** `lib/providers/history_provider.dart`

**Purpose:** Manages scan history (past plant scans)

**Key Methods:**
```dart
// Load scan history for user
Future<void> loadHistory(String userId)

// Refresh history (pull-to-refresh)
Future<void> refreshHistory(String userId)

// Delete specific scan
Future<bool> deleteScan(String scanId)

// Get scan by ID
ScanResult? getScanById(String scanId)

// Clear history state (on logout)
void clearHistory()
```

**State:**
```dart
List<ScanResult> scanHistory  // List of user's scans
bool isLoading                // Loading indicator
String? errorMessage          // Error message
bool get hasScans             // Whether user has any scans
int get scanCount             // Number of scans
```

**Usage Example:**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final authProvider = context.read<AuthProvider>();
    final historyProvider = context.read<HistoryProvider>();

    if (authProvider.currentUser != null) {
      historyProvider.loadHistory(authProvider.currentUser!.id);
    }
  });
}

// Display history
final historyProvider = context.watch<HistoryProvider>();

if (historyProvider.isLoading) {
  return CircularProgressIndicator();
}

if (historyProvider.scanHistory.isEmpty) {
  return Text('No scan history');
}

// List of scans
ListView.builder(
  itemCount: historyProvider.scanHistory.length,
  itemBuilder: (context, index) {
    final scan = historyProvider.scanHistory[index];
    return ListTile(
      title: Text(scan.plantName),
      subtitle: Text(scan.deficiencyDetected ?? 'No deficiency'),
    );
  },
);

// Pull to refresh
RefreshIndicator(
  onRefresh: () async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser != null) {
      await historyProvider.refreshHistory(authProvider.currentUser!.id);
    }
  },
  child: ListView(...),
);
```

---

### 4. ScanProvider

**Location:** `lib/providers/scan_provider.dart`

**Purpose:** Manages plant scanning and ML inference

**Key Methods:**
```dart
// Perform scan with ML inference
Future<bool> performScan({required String userId, required File imageFile, required String plantName})

// Clear scan state
void clearScan()
```

**State:**
```dart
ScanResult? currentScan   // Most recent scan result
bool isLoading           // Loading/processing indicator
String? errorMessage     // Error message
bool get hasScan         // Whether a scan is available
```

**Usage Example:**
```dart
// Perform scan
ElevatedButton(
  onPressed: () async {
    final authProvider = context.read<AuthProvider>();
    final scanProvider = context.read<ScanProvider>();

    final success = await scanProvider.performScan(
      userId: authProvider.currentUser!.id,
      imageFile: capturedImage,
      plantName: selectedPlant,
    );

    if (success && scanProvider.currentScan != null) {
      // Navigate to results page
      context.push(AppRoutes.scanResult);
    }
  },
  child: Text('Analyze Plant'),
);

// Display results
final scanProvider = context.watch<ScanProvider>();

if (scanProvider.isLoading) {
  return CircularProgressIndicator();
}

if (scanProvider.currentScan != null) {
  final scan = scanProvider.currentScan!;
  return Column(
    children: [
      Text('Deficiency: ${scan.deficiencyDetected}'),
      Text('Confidence: ${(scan.confidence ?? 0) * 100}%'),
    ],
  );
}
```

---

### 5. ThemeProvider

**Location:** `lib/providers/theme_provider.dart`

**Purpose:** Manages app theme (light/dark mode)

**Key Methods:**
```dart
// Toggle between light and dark mode
Future<void> toggleTheme()

// Set specific theme mode
Future<void> setThemeMode(ThemeMode mode)

// Set light mode
Future<void> setLightMode()

// Set dark mode
Future<void> setDarkMode()

// Initialize theme from saved preference
Future<void> initialize()
```

**State:**
```dart
ThemeMode themeMode       // Current theme mode
bool get isDarkMode       // Whether dark mode is active
bool get isLightMode      // Whether light mode is active
```

**Usage Example:**
```dart
// In MaterialApp
final themeProvider = context.watch<ThemeProvider>();

return MaterialApp.router(
  themeMode: themeProvider.themeMode,
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  routerConfig: router,
);

// Toggle theme button
IconButton(
  icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
  onPressed: () {
    context.read<ThemeProvider>().toggleTheme();
  },
);
```

---

## Common Patterns

### 1. Loading States

Always show loading indicators when async operations are in progress:

```dart
final provider = context.watch<SomeProvider>();

if (provider.isLoading) {
  return Center(child: CircularProgressIndicator());
}

return YourContent();
```

### 2. Error Handling

Display error messages using SnackBar or error widgets:

```dart
void _performAction() async {
  final provider = context.read<SomeProvider>();

  final success = await provider.doSomething();

  if (!mounted) return;

  if (!success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Operation failed'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
```

### 3. Initial Data Loading

Load data when a page opens using `addPostFrameCallback`:

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = context.read<SomeProvider>();
    provider.loadData();
  });
}
```

### 4. Form Validation

Use Form widget with TextFormField validators:

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid, proceed
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
);
```

### 5. Navigation After Success

Navigate after async operations complete:

```dart
void _handleAction() async {
  final provider = context.read<SomeProvider>();

  final success = await provider.doSomething();

  if (!mounted) return; // IMPORTANT: Check if widget is still mounted

  if (success) {
    context.go(AppRoutes.nextPage);
  }
}
```

---

## Creating a New Provider

Follow these steps to add a new provider to the app:

### 1. Create Provider File

Create `lib/providers/my_feature_provider.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:fyllens/data/services/database_service.dart';

class MyFeatureProvider with ChangeNotifier {
  final DatabaseService _databaseService;

  MyFeatureProvider(this._databaseService);

  // ========== STATE ==========

  String? _data;
  bool _isLoading = false;
  String? _errorMessage;

  // ========== GETTERS ==========

  String? get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ========== METHODS ==========

  Future<void> loadData() async {
    _setLoading(true);
    _clearError();

    try {
      _data = await _databaseService.fetchSomeData();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load data: ${e.toString()}');
    }
  }

  // ========== STATE MANAGEMENT HELPERS ==========

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
```

### 2. Register in main.dart

Add to the `MultiProvider` list:

```dart
MultiProvider(
  providers: [
    // ... existing providers
    ChangeNotifierProvider(
      create: (_) => MyFeatureProvider(services.database),
    ),
  ],
  child: const MyApp(),
);
```

### 3. Use in UI

```dart
@override
Widget build(BuildContext context) {
  final myFeatureProvider = context.watch<MyFeatureProvider>();

  if (myFeatureProvider.isLoading) {
    return CircularProgressIndicator();
  }

  return Text(myFeatureProvider.data ?? 'No data');
}
```

---

## Best Practices

### ✅ DO

- **Always** call `notifyListeners()` after state changes
- **Always** check `if (!mounted) return;` after async operations in widgets
- **Use** `context.watch<T>()` for reactive UI updates
- **Use** `context.read<T>()` for one-time method calls
- **Handle** loading states with `isLoading`
- **Handle** errors gracefully with `errorMessage`
- **Make** state fields private (`_field`) and expose via getters
- **Dispose** resources properly (close streams, cancel timers)

### ❌ DON'T

- **Don't** call `context.watch<T>()` inside callbacks or async functions
- **Don't** forget to call `notifyListeners()` after state changes
- **Don't** expose mutable state directly (use getters)
- **Don't** call `setState()` inside a provider (use `notifyListeners()`)
- **Don't** perform async operations in provider constructors
- **Don't** use providers for static utility functions

---

## Troubleshooting

### Provider Not Found Error

```
Error: Could not find the correct Provider<MyProvider> above this Widget
```

**Solution:** Ensure provider is registered in `main.dart` before the widget tree.

### Widget Not Rebuilding

If UI doesn't update when provider state changes:

1. Check you're using `context.watch<T>()` not `context.read<T>()`
2. Verify `notifyListeners()` is called in provider
3. Ensure provider is not created inside the widget (use existing provider)

### State Lost on Hot Reload

Provider state is reset on hot reload (Flutter limitation). Use hot restart for testing state.

---

## Migration Notes

**What changed from the old architecture:**

| Old (Clean Architecture) | New (Simplified) |
|-------------------------|------------------|
| `features/*/domain/usecases/` | ❌ Removed |
| `features/*/domain/repositories/` | ❌ Removed |
| `features/*/data/repositories/` | ❌ Removed |
| GetIt + Injectable | ✅ Service Locator |
| `context.read<GetIt>().get<UseCase>()` | ✅ `context.read<Provider>()` |
| `build_runner` code generation | ❌ Not needed |
| 5-layer architecture | ✅ 2 layers |

**Benefits of new architecture:**

- ✅ 50% less boilerplate code
- ✅ No code generation needed
- ✅ Beginner-friendly
- ✅ Faster development
- ✅ Easier to understand
- ✅ Fewer files to maintain

---

## Resources

- **Provider Package:** https://pub.dev/packages/provider
- **Flutter State Management:** https://docs.flutter.dev/data-and-backend/state-mgmt
- **Provider Documentation:** https://pub.dev/documentation/provider/latest/

---

**Last Updated:** December 9, 2025
**App Version:** 1.0.0
**Flutter Version:** 3.35.7
