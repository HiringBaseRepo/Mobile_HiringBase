# Project: SmartScreen AI (Mobile Frontend)

This document serves as the primary context for AI agents working on the SmartScreen AI mobile application. It outlines the project's architecture, design system, and coding standards to ensure consistency across all developments.

## 🚀 Tech Stack
- **Framework**: Flutter (latest stable)
- **Architecture/State Management**: GetX
- **Navigation**: GetX Named Routing
- **UI Components**: Material 3
- **Typography**: Google Fonts (Primary: `Outfit`)
- **Charts**: `fl_chart`
- **Data Handling**: JSON-based mock data (currently)

## 📁 Project Structure (GetX Pattern)
```text
lib/
├── app/
│   ├── core/           # Global constants (colors, text styles, themes)
│   │   └── values/     # app_colors.dart, app_text_styles.dart
│   ├── data/           # Models, Providers, Repositories
│   ├── modules/        # Feature-based modules (Binding, Controller, View)
│   │   ├── home/       # Home Dashboard (Stats, Charts, Recent Candidates)
│   │   ├── candidates/ # Candidate Screening (Pipeline, Search, AI Scores)
│   │   ├── jobs/       # Job Vacancy Creation (4-step high-fidelity flow)
│   │   └── candidate_detail/ # Candidate Bio & Detailed Information
│   └── routes/         # Routing definitions (app_pages.dart, app_routes.dart)
└── main.dart           # Application entry point
```

## 🎨 Design System & Aesthetics
To maintain the "Premium & State of the Art" feel, all UI elements must use the centralized constants defined in `lib/app/core/values/`.

### 1. Colors (`AppColors`)
- **Background**: `AppColors.background` (`#F8FAFF`)
- **Primary**: `AppColors.primary` (`#2563EB`)
- **Secondary**: `AppColors.secondary` (`#8B5CF6`)
- **Success**: `AppColors.success` (`#4CAF50`)
- **Warning**: `AppColors.warning` (`#F59E0B`)
- **Text Primary**: `AppColors.textPrimary` (`#1E293B`)
- **Text Secondary**: `AppColors.textSecondary` (`#64748B`)
- **Card Background**: `AppColors.cardBackground` (`Colors.white`)

### 2. UI Elements
- **Border Radius**: Use `20.0` or `25.0` for cards and major containers.
- **Shadows**: Use subtle shadows: `BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: Offset(0, 4))`
- **Padding**: Standard horizontal padding is `20.0`.
- **Icons**: Use `Icons.outline` variants where possible for a modern look.

### 3. Typography (`AppTextStyles`)
- Always use `AppTextStyles` which uses `GoogleFonts.outfit()`.
- **Headers**: `AppTextStyles.h1` (28), `h2` (24), `h3` (20).
- **Subheaders**: `AppTextStyles.subHeader1` (18), `subHeader2` (16).
- **Body**: `AppTextStyles.bodyL` (16), `bodyM` (14), `bodyS` (12).

## 🛠️ Coding Standards
- **Centralized UI**: **NEVER** use hardcoded `Color(0xFF...)` or `GoogleFonts.outfit()` in Views. Always refer to `AppColors` and `AppTextStyles`.
- **GetX Usage**:
    - Use `GetView<Controller>` for views.
    - Keep logic in `Controllers`, UI in `Views`, and dependencies in `Bindings`.
    - Use `Obx(() => ...)` for reactive UI updates.
- **Naming Conventions**:
    - Modules: `snake_case`.
    - Classes: `PascalCase`.
    - Methods/Variables: `camelCase`.
- **Components**: Extract repeatable UI elements into private methods or separate widgets.
- **Routing**: Always use `Get.toNamed(Routes.PATH)`.

## 🔄 Common Workflows
- **Adding a New Page**: 
    1. Create a new module folder in `lib/app/modules`.
    2. Define the Route in `app_routes.dart` and `app_pages.dart`.
    3. Implement Binding, Controller, and View.
- **Updating UI**: 
    - Ensure new components match the existing "Soft UI / Glassmorphism" aesthetic.
    - Test responsiveness for different screen sizes using `Expanded`, `Flexible`, and `LayoutBuilder` if necessary.

## 🧠 Current Context
The app is a high-fidelity recruitment dashboard powered by AI insights. Key features include:
- **Dashboard**: Real-time stats, recruitment trends (Bar Chart), and a quick glance at recent candidates with AI match scores.
- **Candidate Pipeline**: A specialized screening queue with search, filtering, and AI-calculated match percentages. Includes an "AI Promo" section highlighting time saved.
- **Job Creation Wizard**: A premium 4-step workflow:
    1. **Step 1: Job Core**: Essential details (Title, Dept, Description, Benefits).
    2. **Step 2: Requirement Builder**: Skills (Required/Preferred), Experience, and Education.
    3. **Step 3: Applicant Form**: Custom field configuration and evaluation/knockout rules.
    4. **Step 4: Publish Control**: Visibility settings, scheduling, and unique Apply Code generation.
- **Success Page**: A "Vacancy Published" confirmation with shareable links and access codes.

When adding features, prioritize AI-driven UX elements (e.g., "AI Insights", "Smart Recommendations", "Match Analysis") to align with the "SmartScreen AI" brand. Ensure all interactions feel fluid and premium.

