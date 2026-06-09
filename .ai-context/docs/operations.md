# Operations — HiringBase Mobile Frontend

---

## Development Commands

```bash
# Install/restore all dependencies
flutter pub get

# Run the app in debug mode (connected device/emulator)
flutter run

# Run the app on a specific device
flutter run -d <device-id>

# List available devices
flutter devices

# Hot reload (press 'r' in running terminal)
# Hot restart (press 'R' in running terminal)

# Analyze code for lint/type errors
flutter analyze

# Run all tests
flutter test

# Build release APK (Android)
flutter build apk --release

# Build app bundle (Android, for Play Store)
flutter build appbundle --release

# Build release IPA (iOS — requires macOS + Xcode)
flutter build ios --release

# Clean build artifacts
flutter clean

# Check for outdated dependencies
flutter pub outdated

# Upgrade dependencies (minor versions)
flutter pub upgrade
```

---

## Authentication & Session

### HR Authentication
- Login is handled by `LoginController` (module: `login/`)
- On successful login, call `AppService.setUser(user)` to persist session
- `AuthMiddleware` checks `AppService.currentRole.value` on every protected route
- Logout: call `AppService.logout()` then navigate to `Routes.LOGIN`

### Applicant (Public Flow)
- No login required
- Applicant identity is tracked via **Ticket ID** (`TKT-YYYY-XXXXX`)
- No session is stored for applicants — each session is stateless from the app's perspective

### `AuthMiddleware` Behavior
```dart
// Enforces:
// 1. User is logged in (currentUser != null) for HR routes
// 2. Role matches the expected role for the target route
```

---

## Role-Based Access

| Module | Required Role | Middleware Enforced |
|---|---|---|
| All `/home`, `/candidates`, `/jobs-*`, `/ranking`, `/analytics`, etc. | `hr` | Yes |
| `/public-vacancy`, `/track-status` | none (public) | No |
| `/login` | none (public) | No |

---

## API Configuration

- **Base URL**: `http://api.hiringbase.com/api/v1`
- **Client**: `ScoringService extends GetConnect` (`lib/app/services/scoring_service.dart`)
- [PERLU DIISI] — Auth token storage (SharedPreferences? SecureStorage?)
- [PERLU DIISI] — Token refresh strategy
- [PERLU DIISI] — Request timeout configuration

---

## Storage

- [PERLU DIISI] — Document upload target (S3/R2/local server?)
- [PERLU DIISI] — Upload path format
- [PERLU DIISI] — File size limits and accepted MIME types for the 6 required documents

---

## Logging

- [PERLU DIISI] — Crash/error reporting tool (Firebase Crashlytics? Sentry?)
- Debug logs are printed via `print()` or `debugPrint()` during development
- Remove all debug `print()` calls before production builds

---

## Environment Configuration

- [PERLU DIISI] — Confirm if `.env` / `flutter_dotenv` is used for API URL configuration
- Currently the API base URL is hardcoded in `ScoringService`:
  ```dart
  static const String apiBaseUrl = 'http://api.hiringbase.com/api/v1';
  ```
  This should be moved to an environment configuration before production.

---

## Build & Release

### Android
1. Ensure `android/app/build.gradle.kts` has correct `applicationId`, `versionCode`, `versionName`
2. Configure signing in `build.gradle.kts` with keystore
3. `flutter build apk --release` or `flutter build appbundle --release`

### iOS
1. Requires macOS + Xcode
2. Configure bundle ID and signing in Xcode
3. `flutter build ios --release`

---

## Code Quality Gates

Before merging any code:

- [ ] `flutter analyze` — zero errors, zero warnings (ideally)
- [ ] `flutter test` — all tests passing
- [ ] No hardcoded colors in widget trees
- [ ] No `print()` statements in production-bound code
- [ ] No `TODO` comments unless tracked in an issue
