---
applyTo: "lib/app/core/**/*.dart"
---

# Core Layer Instructions

> **Scope**: All files under `lib/app/core/**/*.dart`
> **Role**: Design system foundation. Color tokens, text style tokens, and globally reusable stateless widgets. Has no feature-specific dependencies.

---

## Allowed

- Defining color constants in `AppColors`
- Defining text style constants/getters in `AppTextStyles`
- Creating small, stateless, globally-shared widgets in `core/widgets/`
- Using `GoogleFonts.outfit(...)` as the canonical font

---

## Forbidden

- ❌ Importing from `lib/app/modules/` — core must not depend on features
- ❌ Business logic of any kind
- ❌ `Rx` state or GetX controller imports
- ❌ Feature-specific logic or branching

---

## `AppColors` — Color Token Reference

**File**: `lib/app/core/values/app_colors.dart`

| Token | Hex | Usage |
|---|---|---|
| `AppColors.background` | `#F8FAFF` | Page/scaffold background |
| `AppColors.cardBackground` | `#FFFFFF` | Card surfaces |
| `AppColors.surface` | `#F1F5F9` | Secondary surfaces, chips |
| `AppColors.outline` | `#E2E8F0` | Dividers, borders |
| `AppColors.outlineVariant` | `#C3C6D7` | Subtle borders |
| `AppColors.primary` | `#991B1B` | Primary brand, CTA buttons |
| `AppColors.primaryDark` | `#7F1D1D` | Pressed/hover state of primary |
| `AppColors.secondary` | `#8B5CF6` | Secondary accent, status |
| `AppColors.accent` | `#FEF2F2` | Light brand tint (background fills) |
| `AppColors.accentText` | `#991B1B` | Text on accent backgrounds |
| `AppColors.success` | `#4CAF50` | Success states |
| `AppColors.warning` | `#F59E0B` | Warning states |
| `AppColors.error` | `#EF4444` | Error states |
| `AppColors.info` | `#3B82F6` | Info / Interview status |
| `AppColors.interview` | `#F97316` | Interview badge color |
| `AppColors.textPrimary` | `#1E293B` | Main body text |
| `AppColors.textSecondary` | `#64748B` | Subheadings, metadata |
| `AppColors.textTertiary` | `#94A3B8` | Placeholder, disabled text |
| `AppColors.chartPrimary` | `#991B1B` | Chart fill color |
| `AppColors.chartSecondary` | `#FEE2E2` | Chart background/grid |

### Transparency Usage
```dart
// ✅ Correct (non-deprecated)
AppColors.primary.withValues(alpha: 0.1)

// ❌ Deprecated
AppColors.primary.withOpacity(0.1)
```

---

## Typography Standards

**File**: `lib/app/core/values/app_text_styles.dart`
**Font Family**: `Outfit` (via `google_fonts`)

Always use `AppTextStyles` constants. If a style doesn't exist, add it to the file — don't inline `GoogleFonts.outfit()` in widgets.

---

## Adding a New Token

1. Add to `AppColors` or `AppTextStyles` with a descriptive name
2. Add a comment explaining the use case
3. Update the relevant table in this file

---

## Shared Widgets (`core/widgets/`)

Widgets here must be:
- Stateless (or use only local ephemeral state via `StatefulWidget`)
- Feature-agnostic (usable from any module)
- Documented with a `///` class-level comment

**Example**: `app_bottom_nav.dart` — the global bottom navigation bar.

```dart
/// Global bottom navigation bar shared across HR and Applicant flows.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```
