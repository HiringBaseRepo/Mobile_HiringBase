---
applyTo: "lib/app/services/**/*.dart"
---

# Services Layer Instructions

> **Scope**: All files under `lib/app/services/**/*.dart`
> **Role**: Global persistent state (`GetxService`) and API HTTP clients (`GetConnect`). Shared across the entire app lifecycle.

---

## Allowed

- Global `Rx` observable state (only in `GetxService` subclasses)
- HTTP calls using `GetConnect` (`get`, `post`, `put`, `patch`, `delete`)
- Session management (`currentUser`, `currentRole`)
- Business-agnostic helpers (e.g. `isHR`, `isApplicant`)
- Configuring `httpClient.baseUrl` in `onInit()`

---

## Forbidden

- ❌ Widget rendering or `BuildContext` references
- ❌ Navigation calls (`Get.toNamed`, `Get.off`)
- ❌ Module-specific business rule decisions
- ❌ Holding module-level state (use Controllers for that)
- ❌ Hardcoded user-facing strings — services are infrastructure

---

## Existing Services

### `AppService` (`GetxService`)
**File**: `lib/app/services/app_service.dart`
**Purpose**: Global session state

```dart
// Access pattern
final appService = Get.find<AppService>();
appService.currentUser.value   // → User?
appService.currentRole.value   // → 'hr' | 'applicant' | ''
appService.isHR                // → bool
appService.isApplicant         // → bool

// Methods
appService.setRole('hr');
appService.setUser(user);
appService.logout();
```

### `NavigationService` (`GetxService`)
**File**: `lib/app/services/navigation_service.dart`
**Purpose**: Centralized navigation for primary module switching

```dart
// Access pattern
final navService = Get.find<NavigationService>();
navService.navigateTo(Routes.CANDIDATES);
```

### `ScoringService` (`GetConnect`)
**File**: `lib/app/services/scoring_service.dart`
**Purpose**: API client for AI scoring template CRUD
**Base URL**: `http://api.hiringbase.com/api/v1`

```dart
// Endpoints
getTemplate(jobId)                      // GET /scoring/templates/{jobId}
saveTemplate({jobId, ...weights})       // POST /scoring/templates
updateTemplate(templateId, weights)     // PATCH /scoring/templates/{templateId}
```

---

## Adding a New Service

1. Extend `GetxService` for persistent state, or `GetConnect` for HTTP clients
2. Register in `main.dart` or in the root `Binding` via `Get.put()`
3. Do not instantiate services inside Controllers — always use `Get.find<>()`
4. Name the file `<purpose>_service.dart`
5. Document all public methods with `///` doc comments

---

## API Configuration

- Base URL is currently hardcoded in `ScoringService`. Consider moving to a `.env` or config class.
- [PERLU DIISI] — Auth token injection strategy (e.g., adding `Authorization: Bearer ...` header in `onInit`)
- [PERLU DIISI] — Error handling strategy for non-2xx responses

---

## Service Registration Order

Services must be registered before modules that depend on them. Typical order in `main.dart`:

```dart
await Get.putAsync(() => AppService().init());
Get.put(NavigationService());
Get.put(ScoringService());
```
