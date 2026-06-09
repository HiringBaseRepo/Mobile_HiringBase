---
applyTo: "lib/app/modules/*/views/**/*.dart"
---

# Views Layer Instructions

> **Scope**: All files under `lib/app/modules/*/views/**/*.dart`
> **Role**: Reactive UI containers. Render state from Controllers. Handle user events by delegating to Controllers.

---

## Allowed

- Importing and using the corresponding Controller via `Get.find<FeatureController>()`
- Declaring `final controller = Get.find<FeatureController>()` at the top of State/Widget
- Wrapping all reactive sections in `Obx(() => ...)`
- Reading `Rx` properties from the controller (e.g. `controller.isLoading.value`)
- Calling controller methods in response to user gestures (e.g. `onTap: controller.doSomething`)
- Using `AppColors.*` for all color values
- Using `AppTextStyles.*` or `GoogleFonts.outfit(...)` for typography
- Extracting large widget blocks into `views/components/` sub-files
- Using `Get.toNamed(Routes.X)` for sub-page navigation within a module
- Using `NavigationService` for primary module switches (tab changes, main sections)

---

## Forbidden

- ❌ Business logic or conditional decisions (e.g. computing derived values, status checks)
- ❌ Direct database or API calls
- ❌ `Get.find<AppService>()` to mutate global state from within a view
- ❌ `Map<String, dynamic>` as a data-passing mechanism — use typed Models
- ❌ Hardcoded colors: `Color(0xFF...)`, `Colors.white`, `Colors.grey`, etc.
- ❌ Raw interpolated currency symbols — use `r'$'` raw strings in static data
- ❌ Monolithic files over ~300 lines without component extraction
- ❌ Using `.withOpacity(...)` — use `.withValues(alpha: ...)` instead

---

## Design System Standards (Bento UI)

### Colors
```dart
// ✅ Always use tokens
color: AppColors.primary,
color: AppColors.background,
color: AppColors.primary.withValues(alpha: 0.1),

// ❌ Never hardcode
color: Color(0xFF991B1B),
color: Colors.white,
```

### Border Radius
```dart
// Bento containers (cards, panels)
borderRadius: BorderRadius.circular(24.0),  // or 32.0

// Smaller elements (chips, buttons)
borderRadius: BorderRadius.circular(12.0),
```

### Shadows
```dart
boxShadow: [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 20,
    offset: Offset(0, 8),
  ),
],
```

### Typography
```dart
// Use AppTextStyles
style: AppTextStyles.heading1,
style: AppTextStyles.bodyMedium,

// Or GoogleFonts directly with AppColors
style: GoogleFonts.outfit(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: AppColors.textPrimary,
),
```

### Spacing
```dart
// Card gaps
SizedBox(height: 12), // or 16 between cards
// Section gaps  
SizedBox(height: 24),
```

---

## Structural Pattern

```dart
// views/feature_view.dart — state-driven container
class FeatureView extends GetView<FeatureController> {
  const FeatureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildContent();
      }),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Extract large sub-sections to components/
        const _HeaderSection(),
        _ItemList(),
      ],
    );
  }
}
```

---

## Component Extraction Rule

If a widget block:
- Is > ~80 lines, OR
- Represents a distinct visual concept (e.g. a stat card, a form section, a chart tile)

→ Extract it to `views/components/<name>_widget.dart` immediately.

```
views/
├── feature_view.dart          ← container only, orchestrates components
└── components/
    ├── feature_header.dart
    ├── feature_stat_card.dart
    └── feature_item_list.dart
```
