# Architecture — HiringBase Mobile Frontend

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (latest stable), Dart SDK `^3.9.2` |
| **Architecture / State Management** | GetX (`^4.7.3`) — Module-based MVC + Reactive |
| **Navigation** | GetX Named Routing + centralized `NavigationService` |
| **Auth / Session** | Role-based `AuthMiddleware` + `AppService` session state |
| **UI Components** | Material 3, Bento Design System, Google Fonts (`Outfit`) |
| **Image Caching** | `cached_network_image ^3.4.1` |
| **Charts** | `fl_chart ^1.2.0` |
| **Typography** | `google_fonts ^8.1.0` |
| **API Client** | `GetConnect` (built-in GetX HTTP client) |
| **Testing** | `flutter_test` (SDK), `flutter_lints ^5.0.0` |
| **Platform Targets** | Android (primary), iOS |

---

## Architecture Pattern

**Feature-based Modular MVC with GetX**

```
User Interaction → View → Controller → Service/API → Controller (state update) → View (Obx rebuild)
```

Each feature is a self-contained module with its own `Controller`, `Binding`, and `View(s)`. Global concerns (session, navigation, scoring API) live in `services/`.

### Data Flow
```
views → controllers → services → (API / AppService)
              ↓
          data/models (typed, immutable)
              ↓
          core/ (colors, styles, shared widgets)
```

---

## Folder Structure

```text
lib/
├── main.dart                          # App entry point
└── app/
    ├── core/                          # Design system layer
    │   ├── utils/
    │   │   └── simple_cache.dart      # Generic in-memory TTL cache helper
    │   ├── values/
    │   │   ├── app_colors.dart        # Color token definitions
    │   │   └── app_text_styles.dart   # Typography token definitions
    │   └── widgets/
    │       ├── app_bottom_nav.dart    # Global bottom navigation
    │       ├── error_retry_widget.dart # Reusable UI for reload/retry operations
    │       └── pagination_footer.dart # Loading indicator for list pagination
    │
    ├── data/                          # Data layer
    │   └── models/
    │       ├── user_model.dart
    │       ├── vacancy_model.dart
    │       ├── candidate_model.dart
    │       ├── notification_model.dart
    │       ├── interview_model.dart
    │       └── dashboard_stat.dart
    │
    ├── services/                      # Global services
    │   ├── app_service.dart           # Session state (currentUser, currentRole)
    │   ├── navigation_service.dart    # Centralized navigation logic
    │   └── scoring_service.dart       # AI scoring API client (GetConnect)
    │
    ├── routes/                        # Routing layer
    │   ├── app_routes.dart            # Route constant definitions
    │   ├── app_pages.dart             # Route-to-module registration
    │   └── middlewares/
    │       └── auth_middleware.dart   # Role-based route guard
    │
    └── modules/                       # Feature modules
        ├── home/                      # HR dashboard home
        ├── login/                     # Authentication
        ├── jobs/                      # Job creation
        ├── jobs_list/                 # Job listings with filter
        ├── job_detail_hr/             # HR job detail + stats
        ├── candidates/                # Candidate list view
        ├── candidate_detail/          # Individual candidate profile
        ├── ranking/                   # AI-powered candidate ranking
        ├── manual_override/           # Manual score adjustment
        ├── selection/                 # Selection management
        ├── schedule_interview/        # Interview scheduling
        ├── interview_detail/          # Interview detail + link copy
        ├── analytics/                 # Recruitment analytics dashboard
        ├── notifications/             # Notification center
        ├── profile/                   # HR user profile + activity log
        │   └── views/
        │       └── components/        # Split UI parts
        │           ├── profile_header.dart
        │           ├── profile_info_card.dart
        │           └── profile_change_password_section.dart
        ├── settings/                  # App settings
        └── public_vacancy/            # Public applicant flow (no login)
            └── views/
                └── components/        # Multi-step form components
```

Each module follows:
```
<module>/
├── bindings/<module>_binding.dart
├── controllers/<module>_controller.dart
└── views/
    ├── <module>_view.dart
    └── components/          # (for complex modules)
```

---

## Principles

1. **Separation of Concerns** — Each layer has one job. No cross-contamination.
2. **Reactive by Default** — All mutable state is `Rx`. All consuming widgets use `Obx`.
3. **Strong Typing** — No `Map<String, dynamic>` across layer boundaries.
4. **Design Token Compliance** — All UI uses `AppColors` and `AppTextStyles`.
5. **Component Extraction** — No monolithic view files. Complex UIs are split into `components/`.
6. **Package Imports** — All `core/`, `routes/`, `services/` imports use `package:` style.

---

## Coding Standards

| Item | Standard |
|---|---|
| Files | `snake_case.dart` |
| Classes | `PascalCase` |
| Variables / Methods | `camelCase` |
| Private members | `_camelCase` |
| Route constants | `UPPER_SNAKE_CASE` |
| Colors | Always `AppColors.*` |
| Transparency | `.withValues(alpha: x)` (never `.withOpacity`) |
| Font | `Outfit` via `GoogleFonts` |
| Border radius (Bento) | `24.0` / `32.0` |
| Card gap | `12.0` / `16.0` |
| Imports to core/routes/services | `package:uifrontendmobile/app/...` |

---

## Dependency Graph

```
views
  └── controllers
        ├── services (AppService, NavigationService, ScoringService)
        └── data/models

core (no upstream dependencies)
routes (no upstream dependencies, except middleware → services)
```
