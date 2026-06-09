# Agent Working Instructions — HiringBase Mobile Frontend

> This file defines **how the agent should operate** within this repository.
> Read `AGENTS.md` first, then follow the process defined here for every task.

---

## Step 1 — Identify the Scope

Before writing any code, determine which layers are affected:

| File Path Pattern | Layer |
|---|---|
| `lib/app/modules/*/views/**` | **Views** |
| `lib/app/modules/*/controllers/**` | **Controllers** |
| `lib/app/modules/*/bindings/**` | **Bindings** |
| `lib/app/data/models/**` | **Models** |
| `lib/app/services/**` | **Services** |
| `lib/app/core/**` | **Core / Design System** |
| `lib/app/routes/**` | **Routes** |

Then read the corresponding `.instructions.md` file for that layer from `.ai-context/agent-rules/instructions/` before editing.

---

## Step 2 — Understand the Module Structure

Every feature module follows this structure:

```
lib/app/modules/<feature>/
├── bindings/
│   └── <feature>_binding.dart      # GetX dependency injection
├── controllers/
│   └── <feature>_controller.dart   # Business logic + state
└── views/
    ├── <feature>_view.dart          # State-driven container (uses Obx)
    └── components/                  # Sub-views or large widget extracts
        └── <component>_widget.dart
```

**Never** collapse this into fewer files. **Never** put logic into a view file.

---

## Step 3 — Mandatory Self-Check Before Finishing

Run this checklist mentally (or literally, via `flutter analyze`) before marking a task done:

### 🎨 Design System
- [ ] All colors reference `AppColors.*` — no raw `Color(0x...)` or `Colors.*` in widget trees
- [ ] Typography uses tokens from `AppTextStyles` or `GoogleFonts.outfit()`
- [ ] Border radius is `24.0` or `32.0` for Bento containers; `12.0` or `16.0` for cards
- [ ] BoxShadow follows: `BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: Offset(0, 8))`

### 🏗️ Architecture
- [ ] Business logic is in the Controller, not the View
- [ ] No `Map<String, dynamic>` passed between layers — use typed Models
- [ ] `Obx(() => ...)` wraps all reactive UI blocks
- [ ] `NavigationService` used for primary navigation (not bare `Get.toNamed`)
- [ ] `AppService` used for global session state (not a module Controller)

### 📦 Imports
- [ ] Core/routes/services imports use `package:uifrontendmobile/app/...`
- [ ] No circular imports

### 🔒 Role Safety
- [ ] HR-only screens are not accessible by applicants (rely on `AuthMiddleware`)
- [ ] `AppService.currentRole` checked before role-specific logic

### ✅ Code Quality
- [ ] `flutter analyze` produces no errors
- [ ] No `TODO` comments left that weren't explicitly requested
- [ ] All new public classes/methods have a doc comment (`///`)

---

## Preferred Working Style

### Small, Focused Edits
Prefer targeted changes over full-file rewrites. If a file has 200+ lines, understand the structure before editing.

### Design Consistency First
Before adding any new widget, check `AppColors` and `AppTextStyles` for existing tokens. Do not invent new colors.

### Extract Early
If a widget block exceeds ~80 lines or handles a distinct visual concept, extract it to `views/components/` immediately rather than waiting.

### Reactive by Default
All state that affects the UI must be `Rx`. Use `.obs` on controller variables and `Obx(() => ...)` on the consuming widget.

### Comments in English
All code comments and doc comments must be written in English, even if the UI language is Indonesian.

---

## Common Patterns

### Controller boilerplate
```dart
class FeatureController extends GetxController {
  final isLoading = false.obs;
  final items = <ItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    // fetch data...
    isLoading.value = false;
  }
}
```

### Binding boilerplate
```dart
class FeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeatureController>(() => FeatureController());
  }
}
```

### Obx usage
```dart
Obx(() {
  if (controller.isLoading.value) return const CircularProgressIndicator();
  return ListView.builder(
    itemCount: controller.items.length,
    itemBuilder: (_, i) => ItemCard(item: controller.items[i]),
  );
})
```

### Package import style
```dart
// ✅ Correct
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/routes/app_routes.dart';

// ❌ Wrong
import '../../core/values/app_colors.dart';
```
