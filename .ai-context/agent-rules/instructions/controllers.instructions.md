---
applyTo: "lib/app/modules/*/controllers/**/*.dart"
---

# Controllers Layer Instructions

> **Scope**: All files under `lib/app/modules/*/controllers/**/*.dart`
> **Role**: Business logic hub. Manages module state via `Rx` variables. Orchestrates services and handles user-triggered events.

---

## Allowed

- Declaring `Rx` observable variables (`.obs`)
- Defining business rules, status transitions, and validation logic
- Calling `AppService` (`Get.find<AppService>()`) to read/write session state
- Calling `NavigationService` (`Get.find<NavigationService>()`) for primary navigation
- Calling `ScoringService` or other `GetConnect` services for API operations
- Owning derived data getters (e.g. `get rankedCandidates => ...`)
- Calling `Get.snackbar(...)` or `Get.dialog(...)` for user feedback
- Using `onInit()` for data loading, `onClose()` for cleanup

---

## Forbidden

- ❌ `BuildContext` or any widget/Flutter rendering references
- ❌ Business logic decisions inside View files — push all logic here
- ❌ Global session state held as a controller variable — use `AppService`
- ❌ Placing static `Color(0x...)` values in controller logic (colors belong in Views)
- ❌ `Map<String, dynamic>` as the primary data structure — use typed Models
- ❌ Direct HTTP calls bypassing a Service — use `ScoringService` or equivalent

---

## State Management Patterns

### Basic Observable State
```dart
class FeatureController extends GetxController {
  // Primitive observables
  final isLoading = false.obs;
  final selectedId = RxnString(); // nullable String

  // List observable
  final items = <CandidateModel>[].obs;

  // Object observable (nullable)
  final selectedVacancy = Rxn<Vacancy>();
}
```

### Loading Pattern
```dart
Future<void> loadData() async {
  isLoading.value = true;
  try {
    // ... fetch and assign
    items.assignAll(fetchedItems);
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading.value = false;
  }
}
```

### Accessing Global State
```dart
final _appService = Get.find<AppService>();

bool get isHR => _appService.isHR;
User? get currentUser => _appService.currentUser.value;
```

### Navigation (Primary Module Switch)
```dart
final _nav = Get.find<NavigationService>();

void goToCandidates() => _nav.navigateTo(Routes.CANDIDATES);
```

### Navigation (Sub-page within module)
```dart
void openCandidateDetail(String id) {
  Get.toNamed(Routes.CANDIDATE_DETAIL, arguments: {'id': id});
}
```

---

## AI Scoring Integration

When dealing with scoring-related logic, use `ScoringService`:

```dart
final _scoring = Get.find<ScoringService>();

Future<void> saveWeights() async {
  final response = await _scoring.saveTemplate(
    jobId: selectedJobId.value!,
    skillMatch: skillMatchWeight.value,
    experience: experienceWeight.value,
    education: educationWeight.value,
    portfolio: portfolioWeight.value,
    softSkill: softSkillWeight.value,
    administrative: administrativeWeight.value,
  );
  // handle response...
}
```

---

## Manual Override Rules

When `isManualOverride` is set to `true` on a Candidate:
- The score must have been manually adjusted by an HR user
- The UI layer must visually distinguish this candidate (badge, icon, different color)
- The override flag must be preserved in `copyWith` operations

```dart
void overrideScore(String candidateId, int newScore) {
  final idx = candidates.indexWhere((c) => c.id == candidateId);
  if (idx == -1) return;
  candidates[idx] = candidates[idx].copyWith(
    score: newScore,
    isManualOverride: true,
  );
}
```

---

## Naming Conventions

| Item | Convention | Example |
|---|---|---|
| Controller class | `PascalCase` + `Controller` | `CandidateDetailController` |
| Rx variables | `camelCase` | `isLoading`, `selectedJobId` |
| Private methods | `_camelCase` | `_loadCandidates()` |
| Public methods | `camelCase` | `selectJob()`, `changeTab()` |
