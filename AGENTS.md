# AGENTS.md — HiringBase Mobile Frontend

> **Primary AI Agent Contract**. Every agent working on this repository MUST read this file before making any changes.
> Treat every rule here as non-negotiable unless explicitly overridden by the user for a specific task.

---

## Mission

**HiringBase Mobile** is an AI-powered recruitment mobile application built with Flutter + GetX.
It serves two distinct user roles:

- **HR** — Full dashboard access: job vacancy management, candidate review, AI-powered ranking, manual score override, interview scheduling, and analytics.
- **Applicant (Public)** — No login required. Applicants browse vacancies, submit form-based applications (no CV required), upload 6 required documents, and track their application via a Ticket ID.

The application connects to a FastAPI backend (`api.hiringbase.com`) that handles authentication, AI candidate scoring, and data persistence.

---

## Critical Rules

> These rules apply globally across all layers and modules. Violations are **not acceptable**.

1. **Never hardcode colors.** Always use tokens from `AppColors` (`lib/app/core/values/app_colors.dart`). Use `.withValues(alpha: ...)` instead of the deprecated `.withOpacity(...)`.
2. **Never use `Map<String, dynamic>` to pass data between controllers and views.** Always use strong-typed models from `lib/app/data/models/`.
3. **Never place business logic in Views.** Views are reactive UI only. Logic belongs in Controllers.
4. **Never place global state in a Controller.** Use `AppService` (via `Get.find<AppService>()`) for session-level state (`currentUser`, `currentRole`).
5. **Never use direct `Get.toNamed()` for primary module navigation.** Use `NavigationService` instead.
6. **Always use package imports** (`package:uifrontendmobile/app/...`) for references to `core`, `routes`, and `services` — never relative imports for these.
7. **Never write all view code in a single monolithic file** for complex screens. Use `views/components/` to split sub-views and large widgets.
8. **Always wrap reactive UI** that depends on `Rx` variables inside `Obx(() => ...)`.
9. **Never use raw `Color(0x...)` or `Colors.white/grey/etc`** in widget trees — always use `AppColors`.
10. **Use raw strings (`r'$'`)** when writing currency symbols in mock/static data to prevent interpolation errors.

---

## Layer Boundaries

| Layer | Path Pattern | Responsibility |
|---|---|---|
| **views** | `lib/app/modules/*/views/**` | UI rendering, `Obx` reactive bindings, no logic |
| **controllers** | `lib/app/modules/*/controllers/**` | Business logic, state, event handling |
| **bindings** | `lib/app/modules/*/bindings/**` | Dependency injection wiring via GetX |
| **models** | `lib/app/data/models/**` | Immutable, typed data contracts |
| **services** | `lib/app/services/**` | Global persistent state and API clients |
| **core** | `lib/app/core/**` | Design tokens, text styles, reusable global widgets |
| **routes** | `lib/app/routes/**` | Route constants, page registration, middleware |

### Views Layer Rules
- ✅ Allowed: `Obx(() => ...)`, widget composition, reading from controller, calling controller methods on user interaction
- ❌ Forbidden: business logic, direct API calls, `Get.find<>()` to manipulate state directly, `if/else` conditionals that make business decisions

### Controllers Layer Rules
- ✅ Allowed: `Rx` variable declarations, business rules, status transitions, calling `NavigationService`, calling `AppService`, calling service methods
- ❌ Forbidden: direct widget manipulation, `BuildContext` dependency, rendering logic, placing raw `Color(0x...)` values

### Models Layer Rules
- ✅ Allowed: `fromJson`, `toJson`, `copyWith`, immutable fields, `const` constructors
- ❌ Forbidden: business logic, API calls, state management, `Rx` variables

### Services Layer Rules
- ✅ Allowed: global `Rx` state (`GetxService`), `GetConnect` for HTTP, session management
- ❌ Forbidden: widget rendering, navigation calls, business rule decisions

### Core Layer Rules
- ✅ Allowed: `AppColors` tokens, `AppTextStyles`, shared stateless widgets, design system constants
- ❌ Forbidden: feature-specific logic, importing from `modules/`

---

## Core Domain Rules

### User Roles
| Role | Login Required | Access |
|---|---|---|
| `hr` | Yes | Full dashboard: Jobs, Candidates, Ranking, Interview, Analytics, Profile |
| `applicant` | No | Public Vacancy browser, Application form, Track Status |

### Entity Overview
| Entity | Key Fields |
|---|---|
| `User` | `id`, `name`, `email`, `role` |
| `Vacancy` | `id`, `title`, `department`, `location`, `type`, `salary`, `status`, `applicantCount` |
| `Candidate` | `id`, `name`, `role`, `status`, `score`, `isManualOverride`, `appliedAt` |
| `Notification` | (see `notification_model.dart`) |

### Vacancy Status Flow
```
draft → published → closed
```

### Candidate Status Flow
```
Applied → Reviewed → Interview → (Accepted | Rejected)
```
Manual overrides can set `isManualOverride = true`, which must be visually indicated in the UI.

### AI Scoring Weights
Scoring templates are configured per-job and stored via the backend (`ScoringService`). Weights:
- `skill_match_weight`
- `experience_weight`
- `education_weight`
- `portfolio_weight`
- `soft_skill_weight`
- `administrative_weight`

All weights must sum to a meaningful total. The score is an integer (0–100).

### Public Applicant Flow (Ticket-Based)
1. **Job Detail** → Bento-style with Hero Card and Benefits Grid
2. **Personal Info Form** → Name, Email, WhatsApp (all required)
3. **Document Upload** → 6 mandatory docs: CV, Ijazah, KTP, SKCK, Surat Sehat, Sertifikat (visual feedback per item)
4. **Success Screen** → Display generated Ticket ID (format: `TKT-YYYY-XXXXX`)

**Duplicate prevention**: Mock check by Email + Vacancy ID.

### Naming Conventions
| Scope | Convention |
|---|---|
| Files / Modules | `snake_case` |
| Classes | `PascalCase` |
| Methods / Variables | `camelCase` |
| Route constants | `UPPER_SNAKE_CASE` (in `Routes`) |

---

## Security & Operations

### Authentication
- HR users authenticate via the Login module (`Routes.LOGIN`).
- Session state is held in `AppService` (`currentUser`, `currentRole`).
- All internal routes are protected by `AuthMiddleware` (enforces role consistency and prevents unauthorized access).
- Applicants do **not** log in — they use a public flow.

### Route Protection
- `AuthMiddleware` is applied at the route level in `app_pages.dart`.
- Middleware must check both authentication status and role before allowing navigation.

### API
- Base URL: `http://api.hiringbase.com/api/v1`
- HTTP client configured in `ScoringService` via `GetConnect`.
- [PERLU DIISI] — Full API auth header strategy (Bearer token, etc.)

### Development Commands
```bash
# Run the app in debug mode
flutter run

# Get dependencies
flutter pub get

# Analyze code
flutter analyze

# Run tests
flutter test

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release
```

---

## AI Context Map

All detailed documentation is in `.ai-context/`. Read the relevant file before editing a layer.

| File | Contents |
|---|---|
| [`.ai-context/agent-rules/agent-instructions.md`](.ai-context/agent-rules/agent-instructions.md) | How the agent should work: layer identification, self-check, style |
| [`.ai-context/agent-rules/instructions/views.instructions.md`](.ai-context/agent-rules/instructions/views.instructions.md) | Specific rules for the Views layer |
| [`.ai-context/agent-rules/instructions/controllers.instructions.md`](.ai-context/agent-rules/instructions/controllers.instructions.md) | Specific rules for the Controllers layer |
| [`.ai-context/agent-rules/instructions/models.instructions.md`](.ai-context/agent-rules/instructions/models.instructions.md) | Specific rules for the Models layer |
| [`.ai-context/agent-rules/instructions/services.instructions.md`](.ai-context/agent-rules/instructions/services.instructions.md) | Specific rules for the Services layer |
| [`.ai-context/agent-rules/instructions/core.instructions.md`](.ai-context/agent-rules/instructions/core.instructions.md) | Specific rules for the Core design system layer |
| [`.ai-context/docs/architecture.md`](.ai-context/docs/architecture.md) | Tech stack, folder structure, architecture principles |
| [`.ai-context/docs/domain-rules.md`](.ai-context/docs/domain-rules.md) | Entities, status flows, business rules, API conventions |
| [`.ai-context/docs/operations.md`](.ai-context/docs/operations.md) | Security, dev commands, deployment |
| [`.ai-context/docs/ai-architecture.md`](.ai-context/docs/ai-architecture.md) | AI scoring pipeline, ScoringService, fallback strategy |

---

## Reference Docs
- [`pubspec.yaml`](pubspec.yaml) — All dependencies
- [`lib/app/core/values/app_colors.dart`](lib/app/core/values/app_colors.dart) — Color token source of truth
- [`lib/app/core/values/app_text_styles.dart`](lib/app/core/values/app_text_styles.dart) — Typography tokens
- [`lib/app/routes/app_routes.dart`](lib/app/routes/app_routes.dart) — All route constants
- [`lib/app/routes/app_pages.dart`](lib/app/routes/app_pages.dart) — Route-to-module registration

---

## Definition of Done

A task is **only complete** when ALL of the following are true:

- [ ] No hardcoded `Color(0x...)` or `Colors.*` values in widget trees — `AppColors` used throughout
- [ ] No `Map<String, dynamic>` passed between controller and view — typed models used
- [ ] Business logic is in a Controller, not in a View or Model
- [ ] All reactive UI blocks use `Obx(() => ...)`
- [ ] All imports to `core/`, `routes/`, `services/` use package-style imports
- [ ] Complex view screens use `views/components/` sub-files; no single-file monoliths over ~300 lines
- [ ] `NavigationService` used for primary module switching (not bare `Get.toNamed`)
- [ ] `flutter analyze` passes with no errors
- [ ] `flutter test` passes (if tests exist for the modified area)
- [ ] All new public methods and classes have doc comments
- [ ] UI passes visual inspection: Bento design, consistent radius (24/32), spacing (12/16), `Outfit` font
